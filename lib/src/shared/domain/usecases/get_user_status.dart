import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class GetUserStatus {
  final UserRepo _repo;

  GetUserStatus(this._repo);

  Future<UserStatus?> call(String uid) async {
    return await _repo.getStatus(uid);
  }
}
