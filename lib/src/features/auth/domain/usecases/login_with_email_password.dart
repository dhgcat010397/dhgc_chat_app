import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginWithEmailAndPasswordUsecase {
  final LoginRepo _repo;

  LoginWithEmailAndPasswordUsecase(this._repo);

  Future<UserEntity?> call(String email, String password) async =>
      await _repo.loginWithEmailAndPassword(email, password);
}
