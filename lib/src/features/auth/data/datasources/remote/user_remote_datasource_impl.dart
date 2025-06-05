import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/core/helpers/error_helper.dart';
import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/data/datasources/remote/user_remote_datasource.dart';

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final FirestoreService _firestoreService;

  UserRemoteDatasourceImpl(this._firestoreService);

  @override
  Future<bool> checkUserExits(String uid, {BuildContext? context}) async {
    try {
      final userExists = await _firestoreService.checkDocumentExists(
        collection: 'users',
        docId: uid,
      );

      debugPrint('🔄 User existence check for $uid: $userExists');

      return userExists;
    } on FirebaseException catch (e) {
      // Firebase-specific errors
      debugPrint('🔥 Firebase error checking user: ${e.code} - ${e.message}');

      final errorMessage = ErrorHelper.showFirebaseError(e.code, 'check exits');
      throw Exception(errorMessage);
    } on PlatformException catch (e) {
      // Mobile platform errors
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device operation failed');
    } catch (e, stackTrace) {
      // Generic errors
      debugPrint('❗ Unexpected error checking user: $e\n$stackTrace');
      throw Exception('Failed to verify user existence. Please try again.');
    }
  }

  @override
  Future<String?> addUser(UserEntity? user, {BuildContext? context}) async {
    if (user != null) {
      final userData = user.toModel().toJson();

      /// 'searchKey' can be used for searching users by their email's first letter
      final searchKey = user.email.substring(0, 1).toUpperCase();

      userData.addAll({
        'searchKey': searchKey,
        'createdAt': FieldValue.serverTimestamp(),
      });

      try {
        final uid = await _firestoreService.setDocument(
          collection: 'users',
          docId: user.uid,
          data: userData,
        );

        debugPrint('✅ User ${user.uid} added successfully');

        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User added successfully')),
          );
        }

        return uid;
      } on FirebaseException catch (e) {
        // Firebase-specific errors
        debugPrint('🔥 Firebase error adding user: ${e.code} - ${e.message}');

        final errorMessage = ErrorHelper.showFirebaseError(e.code, 'add');
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
        throw Exception(errorMessage);
      } on PlatformException catch (e) {
        // Mobile platform errors
        debugPrint('📱 Platform error: ${e.code} - ${e.message}');
        throw Exception('Device operation failed');
      } catch (e, stackTrace) {
        // Generic errors
        debugPrint('❗ Unexpected error adding user: $e\n$stackTrace');
        throw Exception('Failed to add user');
      }
    }

    return null;
  }

  @override
  Future<void> updateUser(UserEntity? user, {BuildContext? context}) async {
    if (user != null) {
      final userData = user.toModel().toJson();

      /// 'searchKey' can be used for searching users by their email's first letter
      final searchKey = user.email.substring(0, 1).toUpperCase();

      userData.addAll({
        'searchKey': searchKey,
        'createdAt': FieldValue.serverTimestamp(),
      });

      try {
        await _firestoreService.updateDocument(
          collection: 'users',
          docId: user.uid,
          updates: userData,
        );

        debugPrint('🔄 User data updated successfully: $userData');

        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
        }
      } on FirebaseException catch (e) {
        // Firebase-specific errors
        debugPrint('🔥 Firebase error updating user: ${e.code} - ${e.message}');

        final errorMessage = ErrorHelper.showFirebaseError(e.code, 'update');
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
        throw Exception(errorMessage);
      } on PlatformException catch (e) {
        // Mobile platform errors
        debugPrint('📱 Platform error: ${e.code} - ${e.message}');
        throw Exception('Device operation failed');
      } catch (e, stackTrace) {
        // Generic errors
        debugPrint('❗ Unexpected error updating user: $e\n$stackTrace');
        throw Exception('Failed to update user');
      }
    }
  }

  @override
  Future<void> deleteUser(String uid, {BuildContext? context}) async {
    try {
      await _firestoreService.deleteDocument(collection: 'users', docId: uid);

      debugPrint('🗑️ Successfully deleted user $uid');

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      }
    } on FirebaseException catch (e) {
      // Firebase-specific errors
      debugPrint('🔥 Firebase error deleting user: ${e.code} - ${e.message}');

      final errorMessage = ErrorHelper.showFirebaseError(e.code, 'delete');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      throw Exception(errorMessage);
    } on PlatformException catch (e) {
      // Mobile platform errors
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device operation failed');
    } catch (e, stackTrace) {
      // Generic errors
      debugPrint('❗ Unexpected error updating user: $e\n$stackTrace');
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<UserEntity?> getUserInfo(String uid) async {
    try {
      // Input validation
      if (uid.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      // Get document from Firestore
      final snapshot = await _firestoreService.getDocument(
        collection: 'users',
        docId: uid,
      );

      // Check if document exists
      if (snapshot == null) {
        throw Exception('User not found');
      }

      // Convert data to typed map
      final userData = snapshot;

      final userInfo = UserEntity(
        uid: userData['uid'],
        username: userData['email'].split('@')[0] ?? '',
        email: userData['email'],
        displayName: userData['displayName'],
        imgUrl: userData['imgUrl'],
      );

      debugPrint('✅ Fetched user info for $uid');

      return userInfo;
    } on FirebaseException catch (e) {
      // Firebase-specific errors
      debugPrint('🔥 Firebase error fetching  user: ${e.code} - ${e.message}');

      final errorMessage = ErrorHelper.showFirebaseError(e.code, 'delete');

      throw Exception(errorMessage);
    } on PlatformException catch (e) {
      // Mobile platform errors
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device operation failed');
    } on ArgumentError catch (e) {
      debugPrint('❌ Invalid arguments: $e');
      throw Exception(e.message);
    } catch (e, stackTrace) {
      // Generic errors
      debugPrint('❗ Unexpected error: $e\n$stackTrace');
      throw Exception('Failed to fetch user information');
    }
  }
}
