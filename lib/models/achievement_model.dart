import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

class AchievementModel extends BaseModel {
  AchievementModel({
    @required this.badge,
    @required this.unlocked,
  });

  AchievementModel.fromSnapshot(DocumentSnapshot snapshot) {
    badge = snapshot.data['badge'];
    unlocked = snapshot.data['unlocked'];
  }
  
  DocumentReference badge;
  Timestamp unlocked;

  @override
  String toString() {
    return '''
    badge: $badge
    unlocked: $unlocked
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'badge': badge,
      'unlocked': unlocked,
    };
  }
}