import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/messaging_transformer.dart';
import 'package:swat_nation/models/private_message_model.dart';

/// BLoC containing logic for private messaging.
class MessagingBloc extends BaseBloc with MessagingTransformer {
  MessagingBloc({
    @required this.uid,
  });

  final Firestore _firestore = Firestore.instance;
  final String uid;

  Stream<List<PrivateMessageModel>> conversation(String recipientUid) {
    return _firestore
      .collection('messages/$uid/conversations/$recipientUid/list')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .transform(transformConversation);
  }

  Future<void> send(PrivateMessageModel model, String recipientUid) async {
    await _firestore
      .collection('messages/$uid/conversations/$recipientUid/list')
      .add(model.toMap());
    
    await _firestore
      .collection('messages/$recipientUid/conversations/$uid/list')
      .add(model.toMap());
  }

  Future<void> clear(String receipientUid) {
    return _firestore
      .document('messages/$uid/conversations/$receipientUid')
      .delete();
  }

  @override
  void dispose() {
    print('ConversationBloc disposed');
  }
}
