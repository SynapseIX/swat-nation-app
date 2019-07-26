import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Detects if the device runs iOS and belongs
/// to the 4-inch screen family: iPhone 5, 5s, and SE.
///
/// Returns `true` if the device is running iOS and
/// the screen dimensions match the ones of devices
/// in the 4-inch screen family.
bool iPhoneSE(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double maxLength = math.max(screenWidth, screenHeight);
  
  return Platform.isIOS && maxLength == 568.0;
}

/// Detects if the device runs iOS and belongs
/// to the X family: iPhone X, iPhone XR, iPhone XS,
/// and iPhone XS Max.
///
/// Returns `true` if the device is running iOS and
/// the screen dimensions match the ones of devices
/// in the X family.
bool iPhoneX(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double maxLength = math.max(screenWidth, screenHeight);
  return Platform.isIOS && maxLength >= 812.0;
}

/// Detects if the device is running Android.
/// 
/// Returns `true` if the device is running Android.
bool isAndroid() {
  return Platform.isAndroid;
}
