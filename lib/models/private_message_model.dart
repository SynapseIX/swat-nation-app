import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instace of a private message.
class PrivateMessageModel extends BaseModel {
  PrivateMessageModel({
    @required this.uid,
    @required this.timestamp,
  });

  PrivateMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.data['uid'];
    timestamp = snapshot.data['timestamp'];
  }

  String uid;
  Timestamp timestamp;

  @override
  String toString() {
    return '''
    uid: $uid
    timestamp: $timestamp
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'timestamp': timestamp,
    };
  }
}
