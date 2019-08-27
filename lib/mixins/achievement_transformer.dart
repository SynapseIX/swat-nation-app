// Mixin with method to transform achievements and badges.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/achievement_model.dart';

class AchievementTransformer {
  final StreamTransformer<QuerySnapshot, List<AchievementModel>> transformAchievements
    = StreamTransformer<QuerySnapshot, List<AchievementModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<AchievementModel>> sink) {
          if (snapshot.documents.isNotEmpty) {
            final List<AchievementModel> data = 
              snapshot.documents.map((DocumentSnapshot document) {
                return AchievementModel.fromSnapshot(document);
              }).toList();
            sink.add(data);
          } else {
            sink.addError('There are no achievements');
          }
        }
      );
}