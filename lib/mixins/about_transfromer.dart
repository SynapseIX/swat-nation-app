import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/about_model.dart';

/// Mixin that contains about us section transformers.
class AboutTransformer {
  final StreamTransformer<DocumentSnapshot, AboutModel> transformAbout
    = StreamTransformer<DocumentSnapshot, AboutModel>.fromHandlers(
      handleData: (DocumentSnapshot snapshot, EventSink<AboutModel> sink) {
        sink.add(AboutModel.fromSnapshot(snapshot));
      }
    );
}
