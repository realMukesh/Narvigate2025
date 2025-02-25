import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
final ThemeData appThemeData = ThemeData(
  primaryColor: colorPrimary,
  primaryColorDark: colorGray,
  appBarTheme: const AppBarTheme(backgroundColor: appBarColor),
  fontFamily: 'Roboto',
  useMaterial3: false,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ),
);

// App border radius styles
class AppBorderRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16.0));
  static BorderRadius circular() {
    return BorderRadius.circular(100.0);
  }
}