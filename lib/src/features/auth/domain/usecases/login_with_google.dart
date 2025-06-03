import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/repo/login_repo.dart';

class LoginWithGoogleUsecase {
  final LoginRepo _repo;

  LoginWithGoogleUsecase(this._repo);

  Future<UserEntity?> call() async => await _repo.loginWithGoogle();
}
