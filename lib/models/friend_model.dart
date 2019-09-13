import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instance of a friend.
class FriendModel extends BaseModel {
  FriendModel({
    @required this.incoming,
    this.uid,
    this.dateAdded,
    this.accepted = false,
  });

  FriendModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.reference.documentID;
    dateAdded = snapshot.data['dateAdded'];
    incoming = snapshot.data['incoming'];
    accepted = snapshot.data['accepted'];
  }

  String uid;
  Timestamp dateAdded;
  bool incoming;
  bool accepted;

  @override
  String toString() {
    return '''
    uid: $uid
    dateAdded: $dateAdded
    incoming: $incoming
    accepted: $accepted
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateAdded': dateAdded,
      'incoming': incoming,
      'accepted': accepted,
    };
  }
}
