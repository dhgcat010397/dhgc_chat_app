import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FStorageService {
  static final FStorageService _instance = FStorageService._internal();
  final FirebaseStorage _storage;

  factory FStorageService() => _instance;

  FStorageService._internal() : _storage = FirebaseStorage.instance {
    // Configure storage settings (optional)
    _storage.setMaxUploadRetryTime(const Duration(seconds: 10));
    _storage.setMaxOperationRetryTime(const Duration(seconds: 10));
  }

  // ========== File Operations ==========
  Future<String> uploadFile({
    required String path,
    required File file,
    SettableMetadata? metadata,
  }) async {
    try {
      final ref = _storage.ref(path);
      await ref.putFile(file, metadata);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageFailure.fromCode(e.code);
    } catch (e) {
      throw const StorageFailure();
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw StorageFailure.fromCode(e.code);
    } catch (e) {
      throw const StorageFailure();
    }
  }

  Future<void> deleteFiles(List<String> urls) async {
    try {
      await Future.wait(urls.map((url) => deleteFile(url)));
    } on FirebaseException catch (e) {
      throw StorageFailure.fromCode(e.code);
    } catch (e) {
      throw const StorageFailure();
    }
  }

  Future<void> deleteFolder(String path) async {
    try {
      final ListResult result = await _storage.ref(path).listAll();
      // Delete all files in the folder
      for (final Reference ref in result.items) {
        await ref.delete();
      }
      // Recursively delete all subfolders
      for (final Reference prefix in result.prefixes) {
        await deleteFolder(prefix.fullPath);
      }
    } on FirebaseException catch (e) {
      throw StorageFailure.fromCode(e.code);
    } catch (e) {
      throw const StorageFailure();
    }
  }
}

// Custom exception class
class StorageFailure implements Exception {
  final String message;

  const StorageFailure([this.message = 'Storage operation failed']);

  factory StorageFailure.fromCode(String code) {
    switch (code) {
      case 'object-not-found':
        return const StorageFailure('File not found');
      case 'unauthorized':
        return const StorageFailure('Permission denied');
      default:
        return const StorageFailure();
    }
  }
}
