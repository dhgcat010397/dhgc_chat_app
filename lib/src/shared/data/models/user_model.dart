import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/core/utils/mappers/entity_convertable.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class UserModel extends Equatable
    with EntityConvertible<UserModel, UserEntity> {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? imgUrl;
  final String? searchKey;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName = "",
    this.imgUrl = "",
    this.searchKey = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String? ?? "",
      imgUrl: json['imgUrl'] as String? ?? "",
      searchKey: json['searchKey'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'displayName': displayName,
      'imgUrl': imgUrl,
      'searchKey': searchKey,
    };
  }

  @override
  List<Object?> get props => [
    uid,
    username,
    email,
    displayName,
    imgUrl,
    searchKey,
  ];

  @override
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      email: email,
      displayName: displayName,
      imgUrl: imgUrl,
      searchKey: searchKey,
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? displayName,
    String? imgUrl,
    String? searchKey,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      imgUrl: imgUrl ?? this.imgUrl,
      searchKey: searchKey ?? this.searchKey,
    );
  }
}
