import 'package:flutter/material.dart';
import 'package:swat_nation/base/base_theme.dart';

/// Dark theme.
class DarkTheme extends BaseTheme {
  static const String name = 'dark';

  @override
  ThemeData get themeData => ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    primaryColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      color: Color(0xFF111111),
    ),
  );
}
