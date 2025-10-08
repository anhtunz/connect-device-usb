import 'product/base/bloc/base_bloc.dart';
import 'product/lang/l10n/app_localizations.dart';
import 'product/navigation/navigation_router.dart';
import 'product/services/language_services.dart';
import 'package:flutter/material.dart';
import 'feature/main/main_bloc.dart';
import 'product/cache/locale_manager.dart';

import 'product/services/theme_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleManager.prefrencesInit();
  runApp(
    BlocProvider(
      child: const MyApp(),
      blocBuilder: () => MainBloc(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setTheme(BuildContext context, ThemeData newTheme) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setTheme(newTheme);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeData? _themeData;
  late MainBloc mainBloc;
  LanguageServices languageServices = LanguageServices();
  ThemeServices themeServices = ThemeServices();
  setLocale(Locale locale) {
    _locale = locale;
    mainBloc.sinkLanguage.add(_locale);
  }

  setTheme(ThemeData theme) {
    _themeData = theme;
    mainBloc.sinkTheme.add(_themeData);
  }

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
  }

  @override
  void didChangeDependencies() {
    languageServices.getLocale().then((locale) => {setLocale(locale)});
    themeServices.getTheme().then((theme) => {setTheme(theme)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final router = goRouter();
    return StreamBuilder<Locale?>(
      stream: mainBloc.streamLanguage,
      initialData: _locale,
      builder: (context, languageSnapshot) {
        return StreamBuilder<ThemeData?>(
          initialData: _themeData,
          stream: mainBloc.streamTheme,
          builder: (context, themeSnapshot) {
            return MaterialApp.router(
              theme: themeSnapshot.data,
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageSnapshot.data,
            );
          },
        );
      },
    );
  }
}
