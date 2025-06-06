import 'package:equatable/equatable.dart';

import 'package:dhgc_chat_app/src/core/utils/mappers/model_convertable.dart';
import 'package:dhgc_chat_app/src/shared/data/models/user_model.dart';

class UserEntity extends Equatable
    with ModelConvertible<UserEntity, UserModel> {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? imgUrl;

  const UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName = "",
    this.imgUrl = "",
  });

  @override
  List<Object?> get props => [uid, username, email, displayName, imgUrl];

  @override
  UserModel toModel() {
    return UserModel(
      uid: uid,
      username: username,
      email: email,
      displayName: displayName,
      imgUrl: imgUrl,
    );
  }
}
