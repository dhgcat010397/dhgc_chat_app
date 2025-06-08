import 'package:dhgc_chat_app/src/shared/domain/repo/user_repo.dart';

class CheckUserExist {
  final UserRepo _repo;

  CheckUserExist(this._repo);

  Future<bool> call(String uid) async {
    return await _repo.checkUserExist(uid);
  }
}
