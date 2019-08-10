import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a user instance.
class UserModel extends BaseModel {
  UserModel({
    @required this.uid,
    @required this.displayName,
    @required this.photoUrl,
    @required this.createdAt,
    this.verified = false,
    this.platform,
    this.gamertag,
    this.twitter,
    this.bio,
    this.private = false,
  });

  UserModel.documentSnapshot(DocumentSnapshot document) {
    uid = document.data['uid'];
    displayName = document.data['displayName'];
    photoUrl = document.data['photoUrl'];
    createdAt = document.data['createdAt'];
    verified = document.data['verified'];
    platform = document.data['platform'];
    gamertag = document.data['gamertag'];
    twitter = document.data['twitter'];
    bio = document.data['bio'];
    private = document.data['private'];
  }
  
  String uid;
  String displayName;
  String photoUrl;
  String platform;
  Timestamp createdAt;
  bool verified;
  String gamertag;
  String twitter;
  String bio;
  bool private;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'verified': verified,
      'platform': platform,
      'gamertag': gamertag,
      'twitter': twitter,
      'bio': bio,
      'private': private,
    };
  }
}
