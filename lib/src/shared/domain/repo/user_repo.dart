import 'package:flutter/material.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';

abstract class UserRepo {
  Future<bool> checkUserExist(String uid, {BuildContext? context});
  Future<String?> addUser(UserEntity? user, {BuildContext? context});
  Future<void> updateUser(UserEntity? user, {BuildContext? context});
  Future<void> deleteUser(String uid, {BuildContext? context});
  Future<UserEntity?> getUserInfo(String uid);
  Future<UserStatus> getStatus(String uid);
  // Optional: Real-time status listener
  Stream<UserStatus> getStatusStream(String uid);
}
