import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/friend_transformer.dart';
import 'package:swat_nation/models/friend_model.dart';

/// BLoC containing logic to manage friends.
class FriendsBloc extends BaseBloc with FriendTransformer {
  FriendsBloc({
    @required this.uid,
  });
  
  final String uid;
  final Firestore _firestore = Firestore.instance;

  Stream<List<FriendModel>> get allFriends => _firestore
    .collection('users/$uid/friends')
    .snapshots()
    .transform(transformFriends);

  @override
  void dispose() {
    print('FriendsBloc disposed');
  }
}
