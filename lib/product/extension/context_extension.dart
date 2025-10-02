import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme_light.dart';
import '../utils/responsive_text_utils.dart';

// MEDIA
extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

// RESPONSIVE TEXT
extension ResponsiveTextStyle on BuildContext {
  TextStyle get h1 => TextStyle(
      fontSize: ResponsiveText.getSize(this, 32), fontWeight: FontWeight.bold);

  TextStyle get h2 => TextStyle(
      fontSize: ResponsiveText.getSize(this, 24), fontWeight: FontWeight.bold);

  TextStyle get h3 => TextStyle(
      fontSize: ResponsiveText.getSize(this, 20), fontWeight: FontWeight.bold);

  TextStyle get responsiveBodyLarge =>
      TextStyle(fontSize: ResponsiveText.getSize(this, 18));

  TextStyle get responsiveBodyLargeWithBold => TextStyle(
      fontSize: ResponsiveText.getSize(this, 18), fontWeight: FontWeight.bold);

  TextStyle get responsiveBodyMedium =>
      TextStyle(fontSize: ResponsiveText.getSize(this, 16));

  TextStyle get responsiveBodyMediumWithBold => TextStyle(
      fontSize: ResponsiveText.getSize(this, 16), fontWeight: FontWeight.bold);

  TextStyle get responsiveBodySmall =>
      TextStyle(fontSize: ResponsiveText.getSize(this, 14));

  TextStyle get responsiveBodySmallWithBold => TextStyle(
      fontSize: ResponsiveText.getSize(this, 14), fontWeight: FontWeight.bold);
  TextStyle dynamicResponsiveSize(double val) =>
      TextStyle(fontSize: ResponsiveText.getSize(this, val));
  TextStyle dynamicResponsiveSizeWithBold(double val) => TextStyle(
      fontSize: ResponsiveText.getSize(this, val), fontWeight: FontWeight.bold);
}

// VALUES
extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double get lowValue => height * 0.01;
  double get normalValue => height * 0.02;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
}

// THEME
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => AppThemeLight.instance.theme.colorScheme;
}

// PADDING ALLL
extension PaddingExtensionAll on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowValue);
  EdgeInsets get paddingNormal => EdgeInsets.all(normalValue);
  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValue);
  EdgeInsets get paddingHigh => EdgeInsets.all(highValue);
}

// PADDING SYMETRIC
extension PaddingExtensionSymetric on BuildContext {
  // VERTICAL PADDİNG
  EdgeInsets get paddingLowVertical => EdgeInsets.symmetric(vertical: lowValue);
  EdgeInsets get paddingNormalVertical => EdgeInsets.symmetric(vertical: normalValue);
  EdgeInsets get paddingMediumVertical => EdgeInsets.symmetric(vertical: mediumValue);
  EdgeInsets get paddingHighVertical => EdgeInsets.symmetric(vertical: highValue);

  // HORIZONTAL PADDİNG
  EdgeInsets get paddingLowHorizontal => EdgeInsets.symmetric(horizontal: lowValue);
  EdgeInsets get paddingNormalHorizontal => EdgeInsets.symmetric(horizontal: normalValue);
  EdgeInsets get paddingMediumHorizontal => EdgeInsets.symmetric(horizontal: mediumValue);
  EdgeInsets get paddingHighHorizontal => EdgeInsets.symmetric(horizontal: highValue);
}

// RANDOM COLOR
extension PageExtension on BuildContext {
  Color get randomColor => Colors.primaries[Random().nextInt(17)];
}

// DURATION
extension DurationExtension on BuildContext {
  Duration get lowDuration => const Duration(milliseconds: 500);
  Duration get normalDuration => const Duration(seconds: 1);
}

// RADIUS
extension RadiusExtension on BuildContext {
  Radius get lowRadius => Radius.circular(width * 0.02);
  Radius get normalRadius => Radius.circular(width * 0.05);
  Radius get highRadius => Radius.circular(width * 0.1);
}
