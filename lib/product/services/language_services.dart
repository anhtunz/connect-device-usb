import 'package:flutter/material.dart';

import '../cache/locale_manager.dart';
import '../constants/enums/locale_keys_enum.dart';
import '../lang/l10n/app_localizations.dart';
import '../lang/language_constants.dart';

class LanguageServices {
  Future<Locale> setLocale(String languageCode) async {
    await LocaleManager.prefrencesInit();
    LocaleManager.instance
        .setStringValue(PreferencesKeys.LANGUAGE_CODE, languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    await LocaleManager.prefrencesInit();
    String languageCode =
    LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE);
    return _locale(languageCode);
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case LanguageConstants.ENGLISH:
        return const Locale(LanguageConstants.ENGLISH, '');
      case LanguageConstants.VIETNAM:
        return const Locale(LanguageConstants.VIETNAM, '');
      default:
        return const Locale(LanguageConstants.VIETNAM, '');
    }
  }
}

AppLocalizations appLocalization(BuildContext context) {
  return AppLocalizations.of(context)!;
}
