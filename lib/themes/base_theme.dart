import 'package:flutter/material.dart';

/// Base class for all app themes.
abstract class BaseTheme {
  final Color primaryColor = const Color(0xFFD30045);
  ThemeData getThemeData();
}
