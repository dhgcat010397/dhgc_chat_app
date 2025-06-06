import 'package:flutter/material.dart';

import 'package:dhgc_chat_app/src/features/auth/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserLocalDatasource localDatasource;
  final UserRemoteDatasource remoteDatasource;

  UserRepoImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<bool> checkUserExits(String uid, {BuildContext? context}) async {
    return await remoteDatasource.checkUserExits(uid, context: context);
  }

  @override
  Future<String?> addUser(UserEntity? user, {BuildContext? context}) async {
    return await remoteDatasource.addUser(user, context: context);
  }

  @override
  Future<void> updateUser(UserEntity? user, {BuildContext? context}) async {
    await remoteDatasource.updateUser(user, context: context);
  }

  @override
  Future<void> deleteUser(String uid, {BuildContext? context}) async {
    await remoteDatasource.deleteUser(uid, context: context);
  }

  @override
  Future<UserEntity?> getUserInfo(String uid) async {
    return await remoteDatasource.getUserInfo(uid);
  }

  @override
  Future<UserStatus> getStatus(String uid) async {
    return await remoteDatasource.getStatus(uid);
  }

  @override
  Stream<UserStatus> getStatusStream(String uid) {
    return remoteDatasource.getStatusStream(uid);
  }
}
