import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/core/utils/mappers/entity_convertable.dart';
import 'package:dhgc_chat_app/src/features/auth/domain/entities/user_entity.dart';

class UserModel extends Equatable
    with EntityConvertible<UserModel, UserEntity> {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? imgUrl;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName = "",
    this.imgUrl = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      imgUrl: json['imgUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'displayName': displayName,
      'imgUrl': imgUrl,
    };
  }

  @override
  List<Object?> get props => [uid, username, email, displayName, imgUrl];

  @override
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      email: email,
      displayName: displayName,
      imgUrl: imgUrl,
    );
  }
}
