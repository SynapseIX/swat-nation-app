import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a chat message instance.
class ChatModel extends BaseModel {
  ChatModel({
    @required this.message,
    @required this.createdAt,
    @required this.author,
    @required this.displayName,
    this.photoUrl,
    this.verified = false,
  });

  ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    message = snapshot.data['message'];
    createdAt = snapshot.data['createdAt'];
    author = snapshot.data['author'];
    displayName = snapshot.data['displayName'];
    photoUrl = snapshot.data['photoUrl'];
    verified = snapshot.data['verified'];
  }

  ChatModel.blank();
  
  String message;
  Timestamp createdAt;
  String author;
  String displayName;
  String photoUrl;
  bool verified;

  @override
  String toString() {
    return '''
    message: $message
    createdAt: $createdAt
    author: $author
    displayName: $displayName
    photoUrl: $photoUrl
    verified: $verified
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'createdAt': createdAt,
      'author': author,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'verified': verified,
    };
  }
}
