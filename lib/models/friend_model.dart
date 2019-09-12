import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instance of a friend.
class FriendModel extends BaseModel {
  FriendModel({
    @required this.uid,
    @required this.dateAdded,
    @required this.outgoing,
    this.pending = true,
  });

  FriendModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.data['uid'];
    dateAdded = snapshot.data['dateAdded'];
    outgoing = snapshot.data['outgoing'];
    pending = snapshot.data['pending'];
  }

  String uid;
  Timestamp dateAdded;
  bool outgoing;
  bool pending;

  @override
  String toString() {
    return '''
    uid: $uid
    dateAdded: $dateAdded
    outgoing: $outgoing
    pending: $pending
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'dateAdded': dateAdded,
      'outgoing': outgoing,
      'pending': pending,
    };
  }
}
