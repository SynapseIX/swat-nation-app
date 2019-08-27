import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';

/// BLoC that contains logic to manage achievements.
class AchievementsBloc extends BaseBloc {
  AchievementsBloc({
    @required this.uid,
  });
  
  static const String badgeCollection = 'badges';

  final Firestore _firestore = Firestore.instance;
  final String uid;

  Stream<dynamic> get allBadges => _firestore
    .collection(badgeCollection)
    .snapshots();
  
  Stream<dynamic> get unlockedAchievements => _firestore
    .collection('users/$uid/achievements')
    .snapshots();

  @override
  void dispose() {
    print('AchievementsBloc disposed');
  }
}
