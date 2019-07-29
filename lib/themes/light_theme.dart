import 'package:flutter/material.dart';

import 'base_theme.dart';

/// Light theme.
class LightTheme extends BaseTheme {
  static const String name = 'light';

  @override
  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorBrightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFFEDEDED),
    );
  }
}
