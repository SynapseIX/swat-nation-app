import 'package:flutter/material.dart';

/// Represents an application UI theme.
enum AppTheme { light, dark }

const Color _primaryColor = Color(0xFFD30045);

/// Light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _primaryColor,
  primaryColorBrightness: Brightness.dark,
);

/// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primaryColor,
  primaryColorBrightness: Brightness.dark,
);
