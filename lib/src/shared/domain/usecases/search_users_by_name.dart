import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/search_users_result.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class SearchUsersByName {
  final UserRepo _repo;

  SearchUsersByName(this._repo);

  Future<SearchUsersResult> call(
    String query, {
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    return await _repo.searchUsersByName(
      query,
      lastDocument: lastDocument,
      limit: limit,
    );
  }
}
