import 'package:dhgc_chat_app/src/shared/domain/entities/user_status.dart';
import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class UpdateUserStatus {
  final UserRepo _repo;

  UpdateUserStatus(this._repo);

  Stream<UserStatus> call(String uid) {
    return _repo.getStatusStream(uid);
  }
}
