import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

abstract class RegisterRepo {
  Future<UserEntity?> registerWithEmailAndPassword(
    String email,
    String password,
    String confirmPassword,
    String fullname,
  );
}
