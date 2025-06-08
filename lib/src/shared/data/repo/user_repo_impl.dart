import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/remote/user_remote_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/search_users_result.dart';

class UserRepoImpl implements UserRepo {
  final UserLocalDatasource localDatasource;
  final UserRemoteDatasource remoteDatasource;

  UserRepoImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<bool> checkUserExist(String uid, {BuildContext? context}) async {
    return await remoteDatasource.checkUserExist(uid, context: context);
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

  @override
  Future<SearchUsersResult> searchUsersByName(
    String query, {
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    return await remoteDatasource.searchUsersByName(
      query,
      lastDocument: lastDocument,
      limit: limit,
    );
  }
}
