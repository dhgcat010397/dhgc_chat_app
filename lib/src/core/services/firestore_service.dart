import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  /// [collectionPath] - The path to the collection (e.g., 'users')
  /// [docId] - The ID of the document
  /// Check if the user document exists in the [collectionPath] collection
  Future<bool> checkDocumentExists({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(docId)
              .get();

      // Return true if the document exists, false otherwise
      return doc.exists;
    } catch (e) {
      // Handle any errors that occur during the check
      debugPrint('Error checking document existence: $e');
      return false;
    }
  }

  /// Get a document with optional caching
  /// Returns DocumentSnapshot or throws exception
  Future<DocumentSnapshot> getDocument({
    required String collectionPath,
    required String docId,
    Source source =
        Source.serverAndCache, // Default: try server first, fallback to cache
  }) async {
    try {
      return await _firestore
          .collection(collectionPath)
          .doc(docId)
          .get(GetOptions(source: source));
    } catch (e) {
      debugPrint('FirestoreService.getDocument error: $e');
      throw Exception('Failed to get document: $e');
    }
  }

  /// Set/overwrite a document (auto-generate ID if docId is null)
  /// Returns the document ID
  Future<String> setDocument({
    required String collectionPath,
    String? docId,
    required Map<String, dynamic> data,
    bool merge = false, // Set true for partial updates
  }) async {
    try {
      final docRef =
          docId != null
              ? _firestore.collection(collectionPath).doc(docId)
              : _firestore.collection(collectionPath).doc();

      await docRef.set(data, SetOptions(merge: merge));
      return docRef.id;
    } catch (e) {
      debugPrint('FirestoreService.setDocument error: $e');
      throw Exception('Failed to set document: $e');
    }
  }

  /// Update specific fields in a document (does not overwrite entire document)
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      debugPrint('FirestoreService.updateDocument error: $e');
      throw Exception('Failed to update document: $e');
    }
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      debugPrint('FirestoreService.deleteDocument error: $e');
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Batch delete multiple documents
  Future<void> batchDelete({
    required String collectionPath,
    required List<String> docIds,
  }) async {
    try {
      final batch = _firestore.batch();

      for (final docId in docIds) {
        final docRef = _firestore.collection(collectionPath).doc(docId);
        batch.delete(docRef);
      }

      await batch.commit();
      debugPrint('Successfully deleted ${docIds.length} documents');
    } catch (e) {
      debugPrint('Error in batch delete: $e');
      throw Exception('Batch delete failed: $e');
    }
  }

  /// Delete a subcollection/document with all its nested data
  Future<void> deleteDocumentWithSubcollections({
    required String documentPath,
  }) async {
    // Note: This requires implementing recursive deletion
    // For production use, consider Cloud Functions instead
    throw UnimplementedError('Complex deletion requires Cloud Functions');
  }
}
