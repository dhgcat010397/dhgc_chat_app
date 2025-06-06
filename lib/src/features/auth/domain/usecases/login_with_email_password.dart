import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginWithEmailAndPassword {
  final LoginRepo _repo;

  LoginWithEmailAndPassword(this._repo);

  Future<UserEntity?> call(String email, String password) async =>
      await _repo.loginWithEmailAndPassword(email, password);
}
