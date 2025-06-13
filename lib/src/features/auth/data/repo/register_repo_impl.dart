import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:dhgc_chat_app/src/core/helpers/error_helper.dart';
import 'package:dhgc_chat_app/src/core/services/auth_service.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/register_repo.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class RegisterRepoImpl implements RegisterRepo {
  final UserLocalDatasource localDatasource;
  final UserRemoteDatasource remoteDatasource;
  final AuthService authService;

  RegisterRepoImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.authService,
  });

  @override
  Future<UserEntity?> registerWithEmailAndPassword(
    String email,
    String password,
    String confirmPassword,
    String fullname,
  ) async {
    try {
      // 1. Register user with Firebase Auth via AuthService
      final userCredential = await authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullname: fullname,
      );

      // 2. Convert Firebase User to UserEntity
      final user = _convertToEntity(userCredential.user!);

      // 3. Optionally save user locally
      await localDatasource.saveUser(user);

      // 4. Return the user entity
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('🔥 Firebase auth error: ${e.code} - ${e.message}');
      throw ErrorHelper.showAuthError(e.code);
    } on PlatformException catch (e) {
      debugPrint('📱 Platform error: ${e.code} - ${e.message}');
      throw Exception('Device authentication failed (${e.code})');
    } catch (e, stackTrace) {
      debugPrint('❗ Unexpected error: $e\n$stackTrace');
      throw Exception('Registration failed. Please try again.');
    }
  }

  UserEntity _convertToEntity(User user) {
    final username = user.email?.split('@')[0] ?? '';

    return UserEntity(
      uid: user.uid,
      username: username,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      imgUrl: user.photoURL,
    );
  }
}
