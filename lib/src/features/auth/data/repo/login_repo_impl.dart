import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:dhgc_chat_app/src/core/helpers/error_helper.dart';
import 'package:dhgc_chat_app/src/core/services/auth_service.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  final UserLocalDatasource localDatasource;
  final UserRemoteDatasource remoteDatasource;
  final AuthService authService;

  LoginRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.authService,
  });

  @override
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password) {
    // TODO: implement loginWithUsernameAndPassword
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    try {
      // 1. Authenticate with Google
      final userCredential = await authService.loginWithGoogle();

      // 2. Convert Firebase User to UserEntity
      final user = _convertToEntity(userCredential.user!);

      // 3. Return success with user entity
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('🔥 Firebase auth error: ${e.code} - ${e.message}');
      throw ErrorHelper.showAuthError(e.code);
    } on PlatformException catch (e) {
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device authentication failed (${e.code})');
    } catch (e, stackTrace) {
      debugPrint('❗ Unexpected error: $e\n$stackTrace');
      throw Exception('Google sign in failed. Please try again.');
    }
  }

  @override
  Future<UserEntity?> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  UserEntity _convertToEntity(User user) {
    final username = user.email?.split('@')[0] ?? '';

    return UserEntity(
      uid: user.uid,
      username: username,
      email: user.email ?? '',
      displayName: user.displayName,
      imgUrl: user.photoURL,
    );
  }
}
