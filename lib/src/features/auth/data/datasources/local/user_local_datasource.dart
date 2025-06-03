import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';

abstract class UserLocalDatasource {
  Future<bool> saveUID(String uid);
  Future<bool> saveUsername(String username);
  Future<bool> saveUserDisplayName(String displayName);
  Future<bool> saveEmail(String email);
  Future<bool> saveImage(String img);
  Future<bool> saveUserInfo(UserEntity user);
}
