import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instance of a conversation.
class ConversationModel extends BaseModel {
  ConversationModel({
    @required this.createdAt,
    this.recipientUid,
  });

  ConversationModel.fromSnapshot(DocumentSnapshot snapshot) {
    recipientUid = snapshot.reference.documentID;
    createdAt = snapshot.data['createdAt'];
  }

  String recipientUid;
  Timestamp createdAt;

  @override
  String toString() {
    return '''
    recipientUid: $recipientUid
    createdAt: $createdAt
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt,
    };
  }
}
