import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeDark extends AppTheme {
  static AppThemeDark? _instance;
  static AppThemeDark get instance {
    _instance ??= AppThemeDark._init();
    return _instance!;
  }

  AppThemeDark._init();

  @override
  ThemeData get theme => FlexThemeData.dark(
    useMaterial3: true,
    scheme: FlexScheme.flutterDash,
    subThemesData: const FlexSubThemesData(
      snackBarBackgroundSchemeColor: SchemeColor.black,
      inputDecoratorRadius: 30,
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      tooltipRadius: 20,
      tooltipWaitDuration: Duration(milliseconds: 500),
      tooltipShowDuration: Duration(milliseconds: 500),
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
}
