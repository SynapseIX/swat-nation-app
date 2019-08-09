import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Formats a `Timestamp`.
///
/// Returns a `String` with the formatted date.
String humanizeTimestamp(Timestamp timestamp) {
  if (timestamp == null) {
    return null;
  }

  final DateFormat format = DateFormat.yMMMMd('en_US');  
  return format.format(timestamp.toDate());
}
