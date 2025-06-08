import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUsersResult extends Equatable {
  final List<UserEntity> users;
  final DocumentSnapshot? lastDocument;
  final bool hasReachedMax;

  const SearchUsersResult({
    required this.users,
    this.lastDocument,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [users, lastDocument, hasReachedMax];

  SearchUsersResult copyWith({
    List<UserEntity>? users,
    DocumentSnapshot? lastDocument,
    bool? hasReachedMax,
  }) {
    return SearchUsersResult(
      users: users ?? this.users,
      lastDocument: lastDocument ?? this.lastDocument,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
