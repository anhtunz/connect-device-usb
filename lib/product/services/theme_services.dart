import 'package:flutter/material.dart';

import '../cache/locale_manager.dart';
import '../constants/enums/app_theme_enums.dart';
import '../constants/enums/locale_keys_enum.dart';
import '../theme/app_theme_dark.dart';
import '../theme/app_theme_light.dart';

class ThemeServices{

  ThemeData _currentTheme(String theme) {
    if (theme == AppThemes.LIGHT.name) {
      return AppThemeLight.instance.theme;
    } else if (theme == AppThemes.DARK.name) {
      return AppThemeDark.instance.theme;
    } else {
      return AppThemeLight.instance.theme;
    }
  }

  Future<ThemeData> getTheme() async {
    await LocaleManager.prefrencesInit();
    String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    return _currentTheme(theme);
  }

  Future<ThemeData> changeTheme(String theme) async {
    await LocaleManager.prefrencesInit();
    LocaleManager.instance
        .setStringValue(PreferencesKeys.THEME, theme);
    return _currentTheme(theme);
  }
}