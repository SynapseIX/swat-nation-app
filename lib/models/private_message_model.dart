import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instace of a private message.
class PrivateMessageModel extends BaseModel {
  PrivateMessageModel({
    @required this.uid,
    @required this.text,
    @required this.timestamp,
  });

  PrivateMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.data['uid'];
    text = snapshot.data['text'];
    timestamp = snapshot.data['timestamp'];
  }

  String uid;
  String text;
  Timestamp timestamp;

  @override
  String toString() {
    return '''
    uid: $uid
    text: $text
    timestamp: $timestamp
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
