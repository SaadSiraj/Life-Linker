import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifelinker/core/constants/preference_keys.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedInStatus(bool status) async {
    await _prefs.setBool(PreferenceKeys.isLoggedIn, status);
  }

  static bool getLoggedInStatus() {
    return _prefs.getBool(PreferenceKeys.isLoggedIn) ?? false;
  }

  static Future<void> saveUID(String uid) async {
    await _prefs.setString(PreferenceKeys.uid, uid);
  }

  static String? getUID() {
    return _prefs.getString(PreferenceKeys.uid);
  }

  static Future<void> saveUserRole(String role) async {
    await _prefs.setString(PreferenceKeys.userRole, role);
  }

  static String? getUserRole() {
    return _prefs.getString(PreferenceKeys.userRole);
  }

  static Future<void> clearSession() async {
    await _prefs.clear();
  }
}