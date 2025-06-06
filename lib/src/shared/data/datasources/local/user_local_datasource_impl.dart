import 'package:dhgc_chat_app/src/core/helpers/shared_pref_helper.dart';
import 'package:dhgc_chat_app/src/shared/data/datasources/local/user_local_datasource.dart';
import 'package:dhgc_chat_app/src/shared/domain/entities/user_entity.dart';

class UserLocalDatasourceImpl implements UserLocalDatasource {
  UserLocalDatasourceImpl();

  static String uidKey = "UID_KEY";
  static String usernameKey = "USERNAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userImgKey = "USER_IMG_KEY";
  static String userDisplayName = "USER_DISPLAYNAME_KEY";

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
  Future<bool> saveUserDisplayName(String displayName) async {
    return await SharedPreferencesHelper.setString(
      userDisplayName,
      displayName,
    );
  }

  @override
  Future<bool> saveImage(String img) async {
    return await SharedPreferencesHelper.setString(userImgKey, img);
  }

  @override
  Future<bool> saveUserInfo(UserEntity user) async {
    final futures = [
      saveUID(user.uid),
      saveUsername(user.username),
      saveEmail(user.email),
      saveUserDisplayName(user.displayName!),
      saveImage(user.imgUrl!),
    ];

    final results = await Future.wait(futures);

    final success = results.any((e) => !e) ? false : true;

    return success;
  }
}
