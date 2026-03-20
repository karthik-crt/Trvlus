import 'package:shared_preferences/shared_preferences.dart';

class LaunchService {
  static const String _key = 'is_first_launch';

  static Future<bool> getFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true; // true = first time
  }

  static Future<void> setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
