import 'package:flutter/material.dart';

import 'base_theme.dart';

/// Dark theme.
class DarkTheme extends BaseTheme {
  static const String name = 'dark';
  
  @override
  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      primaryColorBrightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
