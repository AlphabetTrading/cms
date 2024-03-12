import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _prefs;
  var logger = Logger();
  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
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
}
