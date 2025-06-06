import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginWithApple {
  final LoginRepo _repo;

  LoginWithApple(this._repo);

  Future<UserEntity?> call() async => await _repo.loginWithApple();
}
