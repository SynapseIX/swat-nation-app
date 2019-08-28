import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/mixins/achievement_transformer.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/badge_model.dart';
import 'package:swat_nation/models/user_model.dart';

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
  
  Future<BadgeModel> badgeWithPath(String path) async {
    final DocumentSnapshot snapshot = await _firestore
      .collection('badges')
      .document(path.replaceAll('badges/', ''))
      .snapshots()
      .first;
    
    return BadgeModel.fromSnapshot(snapshot);
  }

  Future<DocumentReference> unlock(AchievementModel model) async {
    final UserBloc userBloc = UserBloc();
    final UserModel user = await userBloc.userByUid(uid);

    final BadgeModel badge = await badgeWithPath(model.badge.path);
    final int score = user.score ?? 0;

    user.score = score + badge.points;
    await userBloc.update(user);
    userBloc.dispose();

    return _firestore
      .collection('users/$uid/achievements')
      .add(model.toMap());
  }

  @override
  void dispose() {
    print('AchievementsBloc disposed');
  }
}
