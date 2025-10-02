import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeLight extends AppTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    _instance ??= AppThemeLight._init();
    return _instance!;
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => FlexThemeData.light(
    useMaterial3: true,
    scheme: FlexScheme.flutterDash,
    bottomAppBarElevation: 20.0,
    subThemesData: const FlexSubThemesData(
      snackBarBackgroundSchemeColor: SchemeColor.surfaceBright,
      inputDecoratorRadius: 30,
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      tooltipRadius: 20,
      tooltipWaitDuration: Duration(milliseconds: 1600),
      tooltipShowDuration: Duration(milliseconds: 1500),
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,

  );
}
