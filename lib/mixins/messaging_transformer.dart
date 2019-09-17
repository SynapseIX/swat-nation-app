import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/private_message_model.dart';

/// Mixin that contains tranformers used in chat screens.
class MessagingTransformer {
  final StreamTransformer<QuerySnapshot, List<PrivateMessageModel>> transformConversation
    = StreamTransformer<QuerySnapshot, List<PrivateMessageModel>>.fromHandlers(
      handleData: (QuerySnapshot snapshot, EventSink<List<PrivateMessageModel>> sink) {
        if (snapshot.documents.isEmpty) {
          sink.addError('Messages appear here.');
        } else {
          final List<PrivateMessageModel> data = snapshot
            .documents.map((DocumentSnapshot document) {
              return PrivateMessageModel.fromSnapshot(document);
            }).toList();
          sink.add(data);
        }
      }
    );
}
