import 'package:flutter/material.dart';

/// Base class for all app themes.
abstract class BaseTheme {
  final Color primaryColor = Colors.pink;
  ThemeData get themeData;
}
