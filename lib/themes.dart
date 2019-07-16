import 'package:flutter/material.dart';

/// Represents an application UI theme.
enum AppTheme { light, dark }

/// Light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFD30045),
  primaryColorBrightness: Brightness.dark,
);

/// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFD30045),
  primaryColorBrightness: Brightness.dark,
);
