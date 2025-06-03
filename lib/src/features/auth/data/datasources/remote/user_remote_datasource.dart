import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';

abstract class UserRemoteDatasource {
  Future<bool> checkUserExits(String uid, {BuildContext? context});
  Future<String?> addUser(UserEntity? user, {BuildContext? context});
  Future<void> updateUser(UserEntity? user, {BuildContext? context});
  Future<void> deleteUser(String uid, {BuildContext? context});
  Future<UserEntity?> getUserInfo(String uid);
}
