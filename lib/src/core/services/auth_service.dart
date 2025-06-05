import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/core/helpers/error_helper.dart';
import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' : null,
  );

  /// Creates/updates user profile in Firestore
  Future<void> _createUserProfileIfNeeded(User user) async {
    try {
      final username = user.email?.split('@')[0] ?? '';

      /// 'searchKey' can be used for searching users by their email's first letter
      final searchKey = user.email?.substring(0, 1).toUpperCase() ?? '';

      await FirestoreService().setDocument(
        collection: 'users',
        docId: user.uid,
        data: {
          'uid': user.uid,
          'username': username,
          'email': user.email,
          'displayName': user.displayName,
          'imgUrl': user.photoURL,
          'searchKey': searchKey,
          'provider': 'google',
          'lastLogin': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        merge: true, // Merge with existing data if any
      );
    } catch (e) {
      debugPrint('⚠️ Failed to update user profile: $e');
      // Non-critical error, don't block login
    }
  }

  /// Handles Google Sign-In flow with Firebase integration
  /// Returns [UserCredential] on success
  /// Throws [Exception] with user-friendly messages on failure
  Future<UserCredential> loginWithGoogle() async {
    try {
      debugPrint('🔵 Starting Google Sign-In flow');

      // 1. Trigger Google Sign-In
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        debugPrint('🟠 User cancelled Google Sign-In');
        throw Exception('Sign in cancelled by user');
      }

      // 2. Obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      // 3. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('🟢 Google authentication successful');

      // 4. Sign in to Firebase with Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // 5. Optional: Update user data in Firestore
      await _createUserProfileIfNeeded(userCredential.user!);

      debugPrint(
        '✅ Successfully signed in with Google: ${userCredential.user?.uid}',
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('🔥 Firebase auth error: ${e.code} - ${e.message}');
      throw ErrorHelper.showAuthError(e.code);
    } on PlatformException catch (e) {
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device authentication failed (${e.code})');
    } catch (e, stackTrace) {
      debugPrint('❗ Unexpected error: $e\n$stackTrace');
      throw Exception('Google sign in failed. Please try again.');
    } finally {
      await _googleSignIn.signOut(); // Clean up Google sign-in state
    }
  }
}
