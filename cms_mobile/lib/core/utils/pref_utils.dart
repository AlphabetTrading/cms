import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _prefs;
  var logger = Logger();

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      logger.d('Shared Preferences initialized');
    });
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    logger.d('Shared Preferences initialized');
  }

  void clearPreferenceData() async {
    await _prefs!.clear();
  }

  Future<void> setThemeData(String themeData) async {
    await _prefs!.setString('themeData', themeData);
  }

  String? getThemeData() {
    try {
      return _prefs!.getString('themeData');
    } catch (e) {
      return "primary";
    }
  }

  Future<void> setAccessToken(String token) async {
    await _prefs!.setString('accessToken', token);
  }

  String? getAccessToken() {
    try {
      return _prefs!.getString('accessToken');
    } catch (e) {
      return null;
    }
  }

  Future<void> setRefreshToken(String token) async {
    await _prefs!.setString('refreshToken', token);
  }

  String? getRefreshToken() {
    try {
      return _prefs!.getString('refreshToken');
    } catch (e) {
      return null;
    }
  }

  Future<void> setUserId(String userId) async {
    await _prefs!.setString('userId', userId);
  }

  String? getUserId() {
    try {
      return _prefs!.getString('userId');
    } catch (e) {
      return null;
    }
  }
}
