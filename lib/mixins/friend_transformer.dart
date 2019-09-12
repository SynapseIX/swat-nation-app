import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/friend_model.dart';

/// Mixin with methods to transform friend streams.
class FriendTransformer {
  final StreamTransformer<QuerySnapshot, List<FriendModel>> transformFriends
    = StreamTransformer<QuerySnapshot, List<FriendModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<FriendModel>> sink) {
          if (snapshot.documents.isNotEmpty) {
            sink.add(snapshot.documents.map((DocumentSnapshot snapshot) {
              return FriendModel.fromSnapshot(snapshot);
            }).toList());
          }
        },
      );
}
