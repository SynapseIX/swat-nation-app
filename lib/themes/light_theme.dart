import 'package:flutter/material.dart';
import 'package:swat_nation/base/base_theme.dart';

/// Light theme.
class LightTheme extends BaseTheme {
  static const String name = 'light';

  @override
  ThemeData get themeData => ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFFEDEDED),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: primaryColor,
    ),
  );
}
