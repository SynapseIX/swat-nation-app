import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/friend_model.dart';

/// Mixin with methods to transform friend streams.
class FriendTransformer {
  final StreamTransformer<QuerySnapshot, List<FriendModel>> friendsTransformer
    = StreamTransformer<QuerySnapshot, List<FriendModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<FriendModel>> sink) {
          if (snapshot.documents.isEmpty) {
            sink.addError('User has no friends.');
          } else {
            sink.add(snapshot.documents.map((DocumentSnapshot doc) {
              return FriendModel(
                uid: doc.data['uid'],
                pending: doc.data['pending'],
              );
            }).toList());
          }
        },
      );
}
