import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

enum UserProvider { email, facebook }

/// Represents a user instance.
class UserModel extends BaseModel {
  UserModel({
    @required this.uid,
    @required this.displayName,
    @required this.createdAt,
    @required this.provider,
    this.photoUrl,
    this.headerUrl,
    this.verified = false,
    this.platform,
    this.gamertag,
    this.twitter,
    this.mixer,
    this.twitch,
    this.bio,
    this.private = false,
  });

  UserModel.fromSnapshot(DocumentSnapshot document) {
    uid = document.data['uid'];
    displayName = document.data['displayName'];
    photoUrl = document.data['photoUrl'];
    createdAt = document.data['createdAt'];
    provider = document.data['provider'] == facebookProvider
      ? UserProvider.facebook
      : UserProvider.email;
    headerUrl = document.data['headerUrl'];
    verified = document.data['verified'];
    platform = document.data['platform'];
    gamertag = document.data['gamertag'];
    twitter = document.data['twitter'];
    mixer = document.data['mixer'];
    twitch = document.data['twitch'];
    bio = document.data['bio'];
    private = document.data['private'];
  }

  UserModel.blank();

  static const String emailProvider = 'email';
  static const String facebookProvider = 'facebook';
  
  String uid;
  String displayName;
  String photoUrl;
  String platform;
  Timestamp createdAt;
  UserProvider provider;
  String headerUrl;
  bool verified;
  String gamertag;
  String twitter;
  String mixer;
  String twitch;
  String bio;
  bool private;

  @override
  String toString() {
    return '''
    uid: $uid
    displayName: $displayName
    photoUrl: $photoUrl
    createdAt: $createdAt
    provider: ${provider == UserProvider.facebook ? facebookProvider : emailProvider}
    headerUrl: $headerUrl
    verified: $verified
    platform: $platform
    gamertag" $gamertag
    twitter: $twitter
    mixer: $mixer
    twitch: $twitch
    bio: $bio
    private: $private
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'provider': provider == UserProvider.facebook ? facebookProvider : emailProvider,
      'headerUrl': headerUrl,
      'verified': verified,
      'platform': platform,
      'gamertag': gamertag,
      'twitter': twitter,
      'mixer': mixer,
      'twitch': twitch,
      'bio': bio,
      'private': private,
    };
  }
}
