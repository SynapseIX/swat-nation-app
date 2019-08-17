import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a video clip.
class ClipModel extends BaseModel {
  ClipModel({
    @required this.userId,
    @required this.videoUrl,
    @required this.random,
  });

  ClipModel.fromSnapshot(DocumentSnapshot document) {
    userId = document.data['userId'];
    videoUrl = document.data['videoUrl'];
    random = document.data['random'];
  }

  ClipModel.blank();
  
  String userId;
  String videoUrl;
  int random;

  @override
  String toString() {
    return '''
    userId: $userId,
    videoUrl: $videoUrl,
    random: $random,
    ''';
  }
  
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'videoUrl': videoUrl,
      'random': random,
    };
  }
}
