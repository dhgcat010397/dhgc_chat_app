import 'package:dhgc_chat_app/src/features/auth/domain/repo/register_repo.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class RegisterWithEmailAndPassword {
  final RegisterRepo _repo;

  RegisterWithEmailAndPassword(this._repo);

  Future<UserEntity?> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullname,
  }) async => await _repo.registerWithEmailAndPassword(
    email,
    password,
    confirmPassword,
    fullname,
  );
}
