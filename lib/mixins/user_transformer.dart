import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/user_model.dart';

/// Mixin with stream transformers for user models.
class UserTransformer {
  final StreamTransformer<QuerySnapshot, List<UserModel>> userTransformer
    = StreamTransformer<QuerySnapshot, List<UserModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<UserModel>> sink) {
          if (snapshot.documents.isEmpty) {
            sink.addError('No users found.');
          } else {
            final List<UserModel> data = snapshot.documents
              .map((DocumentSnapshot document) {
                return UserModel.fromSnapshot(document);
              }).toList();
            sink.add(data);
          }
        },
      );
}
