import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a video clip.
class ClipModel extends BaseModel {
  ClipModel({
    @required this.author,
    @required this.link,
    @required this.random,
    @required this.createdAt,
    this.uid,
    this.title,
  });

  ClipModel.fromSnapshot(DocumentSnapshot document) {
    uid = document.reference.documentID;
    author = document.data['author'];
    link = document.data['link'];
    random = document.data['random'];
    createdAt = document.data['createdAt'];
    title = document.data['title'];
  }

  ClipModel.blank();
  
  String uid;
  String author;
  String link;
  int random;
  Timestamp createdAt;
  String title;

  @override
  String toString() {
    return '''
    uid: $uid
    author: $author
    link: $link
    random: $random
    createdAt: $createdAt
    title: $title
    ''';
  }
  
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'author': author,
      'link': link,
      'random': random,
      'createdAt': createdAt,
      'title': title,
    };
  }
}
