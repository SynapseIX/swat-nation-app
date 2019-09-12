import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instance of a friend.
class FriendModel extends BaseModel {
  FriendModel({
    @required this.uid,
    this.pending = true,
  });

  FriendModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.data['uid'];
    pending = snapshot.data['pending'];
  }

  String uid;
  bool pending;

  @override
  String toString() {
    return '''
    uid: $uid
    pending: $pending
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'pending': pending,
    };
  }
}
