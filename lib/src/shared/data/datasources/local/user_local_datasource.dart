import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

abstract class UserLocalDatasource {
  Future<bool> saveUID(String uid);
  Future<bool> saveUsername(String username);
  Future<bool> saveFullname(String fullname);
  Future<bool> saveEmail(String email);
  Future<bool> saveImage(String img);
  Future<bool> saveUser(UserEntity user);
}
