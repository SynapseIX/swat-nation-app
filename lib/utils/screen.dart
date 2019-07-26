import 'package:flutter/foundation.dart';

/// Returns the formated aspect ratio between a width and a height.
String getAspectRatio({
  @required double width,
  @required double height,
}) {
  if (width.isNegative || height.isNegative) {
    throw Exception('Values cannot be negative');
  }

  final double gcd = _gcd(width, height);
  return '${width / gcd}:${height / gcd}';
}

// Helpers

/// Finds the  greatest common divisor between numbers `a` and `b`.
double _gcd(double a, double b) {
  return b == 0.0 ? a : _gcd(b, a % b);
}
