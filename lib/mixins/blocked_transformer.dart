import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/blocked_model.dart';

/// Mixin with methods to transform blocked users.
class BlockedTransformer {
  final StreamTransformer<QuerySnapshot, List<BlockedModel>> transformBlocked
    = StreamTransformer<QuerySnapshot, List<BlockedModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<BlockedModel>> sink) {
          if (snapshot.documents.isNotEmpty) {
            sink.add(snapshot.documents.map((DocumentSnapshot snapshot) {
              return BlockedModel.fromSnapshot(snapshot);
            }).toList());
          } else {
            sink.addError('There are no blocked users.');
          }
        },
      );
}
