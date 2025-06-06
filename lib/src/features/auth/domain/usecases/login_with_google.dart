import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginWithGoogle {
  final LoginRepo _repo;

  LoginWithGoogle(this._repo);

  Future<UserEntity?> call() async => await _repo.loginWithGoogle();
}
