import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  static Future<SharedPreferences> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<void> setSetup(String key, bool value) async {
    final prefs = await getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getSetup(String key) async {
    final prefs = await getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> setInvoiceCounter(String key, int value) async {
    final prefs = await getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> getInvoiceCounter(String key) async {
    final prefs = await getInstance();
    return prefs.getInt(key) ?? 0;
  }
}
