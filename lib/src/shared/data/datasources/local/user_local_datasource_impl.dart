import 'package:dhgc_chat_app/src/core/helpers/shared_pref_helper.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class UserLocalDatasourceImpl implements UserLocalDatasource {
  UserLocalDatasourceImpl();

  static String uidKey = "UID_KEY";
  static String usernameKey = "USERNAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userImgKey = "USER_IMG_KEY";
  static String userFullnameKey = "USER_FULLNAME_KEY";

  @override
  Future<bool> saveUID(String uid) async {
    return await SharedPreferencesHelper.setString(uidKey, uid);
  }

  @override
  Future<bool> saveUsername(String username) async {
    return await SharedPreferencesHelper.setString(usernameKey, username);
  }

  @override
  Future<bool> saveEmail(String email) async {
    return await SharedPreferencesHelper.setString(userEmailKey, email);
  }

  @override
  Future<bool> saveFullname(String fullname) async {
    return await SharedPreferencesHelper.setString(userFullnameKey, fullname);
  }

  @override
  Future<bool> saveImage(String img) async {
    return await SharedPreferencesHelper.setString(userImgKey, img);
  }

  @override
  Future<bool> saveUser(UserEntity user) async {
    final futures = [
      saveUID(user.uid),
      saveUsername(user.username),
      saveEmail(user.email),
      saveFullname(user.displayName ?? ""),
      saveImage(user.imgUrl ?? ""),
    ];

    final results = await Future.wait(futures);

    final success = results.every((e) => e);

    return success;
  }
}
