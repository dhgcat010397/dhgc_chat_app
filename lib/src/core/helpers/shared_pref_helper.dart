import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Private static instance
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  static SharedPreferences? _prefs;

  factory SharedPreferencesHelper() {
    return _instance;
  }

  // Private internal constructor
  SharedPreferencesHelper._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.setString(key, value);
  }

  // Đọc String
  static String? getString(String key) {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.getString(key);
  }

  // Lưu bool
  static Future<bool> setBool(String key, bool value) {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.setBool(key, value);
  }

  // Đọc bool (mặc định false nếu không tồn tại)
  static bool getBool(String key) {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.getBool(key) ?? false;
  }

  // Xóa key
  static Future<bool> remove(String key) {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.remove(key);
  }

  // Xóa tất cả
  static Future<bool> clear() {
    assert(_prefs != null, 'SharedPreferences is not initialized!');
    return _prefs!.clear();
  }
}
