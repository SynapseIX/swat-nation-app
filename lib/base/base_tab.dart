import 'package:flutter/material.dart';

/// Base class for tab screens.
abstract class BaseTab extends Widget {
  IconData get icon;
  String get title;
}
