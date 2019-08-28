import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

class AchievementModel extends BaseModel {
  AchievementModel({
    @required this.title,
    @required this.badge,
    @required this.points,
    @required this.unlocked,
    this.description,
  });

  AchievementModel.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    badge = snapshot.data['badge'];
    points = snapshot.data['points'];
    unlocked = snapshot.data['unlocked'];
    description = snapshot.data['description'];
  }
  
  String title;
  String badge;
  int points;
  Timestamp unlocked;
  String description;

  @override
  String toString() {
    return '''
    title: $title
    badge: $badge
    points: $points
    unlocked: $unlocked
    description: $description
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'badge': badge,
      'points': points,
      'unlocked': unlocked,
      'description': description,
    };
  }
}
