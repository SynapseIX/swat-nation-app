import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/chat_model.dart';

/// Mixin that contains tranformers used in chat screens.
class ChatTransformer {
  final StreamTransformer<QuerySnapshot, List<ChatModel>> transformRoom
    = StreamTransformer<QuerySnapshot, List<ChatModel>>.fromHandlers(
      handleData: (QuerySnapshot snapshot, EventSink<List<ChatModel>> sink) {
        if (snapshot.documents.isEmpty) {
          sink.addError('Chat messages show here.');
        } else {
          final List<ChatModel> data = snapshot
            .documents.map((DocumentSnapshot document) {
              return ChatModel.fromSnapshot(document);
            }).toList();
          sink.add(data);
        }
      }
    );
}
