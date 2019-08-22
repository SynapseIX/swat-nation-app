import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_model.dart';

/// Mixin for transforming clips to application model objects.
class ClipTransformer {
  final StreamTransformer<QuerySnapshot, List<ClipModel>> transformClips
    = StreamTransformer<QuerySnapshot, List<ClipModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<ClipModel>> sink) {
          if (snapshot.documents.isEmpty) {
            sink.addError('There are no clips.');
          } else {
            final List<ClipModel> data = snapshot.documents
              .map((DocumentSnapshot document) {
                return ClipModel.fromSnapshot(document);
              }).toList();
            sink.add(data);
          }
        },
      );
  
  final StreamTransformer<QuerySnapshot, ClipModel> transformRandomClip
    = StreamTransformer<QuerySnapshot, ClipModel>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<ClipModel> sink) {
          if (snapshot.documents.isEmpty) {
            sink.addError('There are no clips.');
          } else {
            sink.add(
              ClipModel.fromSnapshot(snapshot.documents.first),
            );
          }
        },
      );

  bool validateLink(String link) {
    if (link == null) {
      return false;
    }

    return link.startsWith(kXboxClipsHost);
  }
}