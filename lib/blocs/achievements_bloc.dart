import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/achievement_transformer.dart';
import 'package:swat_nation/models/achievement_model.dart';

/// BLoC that contains logic to manage achievements.
class AchievementsBloc extends BaseBloc with AchievementTransformer {
  AchievementsBloc({
    @required this.uid,
  });

  final Firestore _firestore = Firestore.instance;
  final String uid;
  
  Stream<List<AchievementModel>> get unlockedAchievements => _firestore
    .collection('users/$uid/achievements')
    .snapshots()
    .transform(transformAchievements);

  @override
  void dispose() {
    print('AchievementsBloc disposed');
  }
}
