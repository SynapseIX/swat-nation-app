import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represent an achievement badge.
class BadgeModel extends BaseModel {
  BadgeModel({
    @required this.points,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
  });

  BadgeModel.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    description = snapshot.data['description'];
    imageUrl = snapshot.data['imageUrl'];
    points = snapshot.data['points'];
  }

  static const String becomeLegend = 'become-legend';
  
  int points;
  String title;
  String description;
  String imageUrl;

  @override
  String toString() {
    return '''
    points: $points
    title: $title
    description: $description
    imageUrl: $imageUrl
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'points': points,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
