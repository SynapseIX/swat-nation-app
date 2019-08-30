import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/swat_art_model.dart';

/// Mixin with stream transformers for announcments.
class SwatArtTransformer {
  final StreamTransformer<QuerySnapshot, List<SwatArtModel>> transformArt
    = StreamTransformer<QuerySnapshot, List<SwatArtModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<SwatArtModel>> sink) {
          if (snapshot.documents.isNotEmpty) {
            sink.add(
              snapshot.documents.map((DocumentSnapshot document) {
                return SwatArtModel.fromSnapshot(document);
              }).toList(),
            );
          } else {
            sink.addError('No announcements found.');
          }
        }
      );
}
