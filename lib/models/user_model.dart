import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Represents a user instance.
class UserModel {
  UserModel({
    @required this.uid,
    this.displayName,
    this.photoUrl,
    this.platform,
    this.createdAt,
    this.bio,
  });

  UserModel.documentSnapshot(DocumentSnapshot document) {
    uid = document.data['uid'];
    displayName = document.data['displayName'];
    photoUrl = document.data['photoUrl'];
    platform = document.data['platform'];
    createdAt = document.data['createdAt'];
    bio = document.data['bio'];
  }
  
  String uid;
  String displayName;
  String photoUrl;
  String platform;
  Timestamp createdAt;
  String bio;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'platform': platform,
      'createdAt': createdAt,
      'bio': bio,
    };
  }
}
