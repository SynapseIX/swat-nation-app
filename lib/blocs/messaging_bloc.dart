import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/messaging_transformer.dart';
import 'package:swat_nation/models/conversation_model.dart';
import 'package:swat_nation/models/private_message_model.dart';

/// BLoC containing logic for private messaging.
class MessagingBloc extends BaseBloc with MessagingTransformer {
  MessagingBloc({
    @required this.uid,
  });

  final Firestore _firestore = Firestore.instance;
  final String uid;

  Stream<List<PrivateMessageModel>> messages(String recipientUid) {
    return _firestore
      .collection('messages/$uid/conversations/$recipientUid/list')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .transform(transformMessages);
  }

  Stream<List<ConversationModel>> get conversations => _firestore
    .collection('messages/$uid/conversations/')
    .orderBy('createdAt', descending: true)
    .snapshots()
    .transform(transformConversations);

  Future<void> send(PrivateMessageModel model, String recipientUid) async {
    final DocumentSnapshot myConvo = await _firestore
      .document('messages/$uid/conversations/$recipientUid')
      .get();
    final DocumentSnapshot theirConvo = await _firestore
      .document('messages/$recipientUid/conversations/$uid')
      .get();
    
    if (!myConvo.exists) {
      await _firestore
        .document('messages/$uid/conversations/$recipientUid')
        .setData(ConversationModel(createdAt: Timestamp.now()).toMap());
    }

    if (!theirConvo.exists) {
      await _firestore
        .document('messages/$recipientUid/conversations/$uid')
        .setData(ConversationModel(createdAt: Timestamp.now()).toMap());
    }

    await _firestore
      .collection('messages/$uid/conversations/$recipientUid/list')
      .add(model.toMap());
    
    await _firestore
      .collection('messages/$recipientUid/conversations/$uid/list')
      .add(model.toMap());
  }

  Future<void> clear(String recipientUid) {
    return _firestore.collection('messages/$uid/conversations/$recipientUid/list')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot document in snapshot.documents) {
          document.reference.delete();
        }
      });
  }

  Future<void> removeConversation(String recipientUid) async {
    await clear(recipientUid);
    return _firestore
      .document('messages/$uid/conversations/$recipientUid')
      .delete();
  }

  @override
  void dispose() {
    print('ConversationBloc disposed');
  }
}
