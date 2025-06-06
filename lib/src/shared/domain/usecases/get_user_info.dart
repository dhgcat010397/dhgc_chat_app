import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class GetUserInfo {
  final UserRepo _repo;

  GetUserInfo(this._repo);

  Future<UserEntity?> call(String uid) async {
    return await _repo.getUserInfo(uid);
  }
}
