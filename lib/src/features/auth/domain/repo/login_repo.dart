import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';

abstract class LoginRepo {
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password);
  Future<UserEntity?> loginWithGoogle();
  Future<UserEntity?> loginWithFacebook();
  Future<UserEntity?> loginWithApple();
}
