import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a video clip.
class ClipModel extends BaseModel {
  ClipModel({
    @required this.author,
    @required this.videoUrl,
    @required this.random,
    @required this.createdAt,
    this.thumbnailUrl,
  });

  ClipModel.fromSnapshot(DocumentSnapshot document) {
    author = document.data['author'];
    videoUrl = document.data['videoUrl'];
    videoUrl = document.data['videoUrl'];
    random = document.data['random'];
    createdAt = document.data['createdAt'];
    thumbnailUrl = document.data['thumbnailUrl'];
  }

  ClipModel.blank();
  
  String author;
  String videoUrl;
  int random;
  Timestamp createdAt;
  String thumbnailUrl;

  @override
  String toString() {
    return '''
    author: $author
    videoUrl: $videoUrl
    random: $random
    createdAt: $createdAt
    thumbnail: $thumbnailUrl
    ''';
  }
  
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'videoUrl': videoUrl,
      'random': random,
      'createdAt': createdAt,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
