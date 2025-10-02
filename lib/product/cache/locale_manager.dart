import 'package:shared_preferences/shared_preferences.dart';

import '../constants/enums/locale_keys_enum.dart';


class LocaleManager {
  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static final LocaleManager _instance = LocaleManager._init();

  SharedPreferences? _preferences;

  static LocaleManager get instance => _instance;

  static Future prefrencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  void setString(PreferencesKeys key, String value) async {
    await _preferences?.setString(key.toString(), value);
  }

  void setInt(PreferencesKeys key, int value) async {
    await _preferences?.setInt(key.toString(), value);
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _preferences!.setString(key.toString(), value);
  }

  String getStringValue(PreferencesKeys key) =>
      _preferences?.getString(key.toString()) ?? '';

  int getIntValue(PreferencesKeys key) =>
      _preferences?.getInt(key.toString()) ?? 0;

  Future<void> deleteStringValue(PreferencesKeys key) async {
    await _preferences!.remove(key.toString());
  }
}
