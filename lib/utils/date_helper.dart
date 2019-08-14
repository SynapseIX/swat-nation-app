import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Formats a `Timestamp` using the provided pattern.
///
/// Returns a `String` with the formatted date.
String humanizeTimestamp(Timestamp timestamp, String pattern) {
  if (timestamp == null || pattern == null) {
    return null;
  }

  final DateFormat format = DateFormat(pattern, 'en_US');  
  return format.format(timestamp.toDate());
}
