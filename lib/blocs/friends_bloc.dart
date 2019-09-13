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
  
  
  final Firestore _firestore = Firestore.instance;
  final String uid;

  Stream<List<FriendModel>> get allFriends => _firestore
    .collection('friends/$uid/list')
    .orderBy('accepted', descending: true)
    .snapshots()
    .transform(transformFriends);

  Future<void> sendFriendRequest(String friendUid) async {
    final bool isPending = await checkPendingRequest(friendUid);

    if (isPending) {
      throw 'Friend request still pending.';
    } else {
      await _firestore
        .collection('friends/$uid/list')
        .document(friendUid)
        .setData(FriendModel(incoming: false).toMap());

      await _firestore
        .collection('friends/$friendUid/list')
        .document(uid)
        .setData(FriendModel(incoming: true).toMap());
    }
  }

  Future<void> removeFriend(String friendUid) async {
    await _firestore.document('friends/$uid/list/$friendUid').delete();
    await _firestore.document('friends/$friendUid/list/$uid').delete();
  }

  Future<bool> checkFriendship(String friendUid) async {
    final DocumentSnapshot myDoc = await _firestore
      .document('friends/$uid/list/$friendUid').get();
    final DocumentSnapshot theirDoc = await _firestore
      .document('friends/$friendUid/list/$uid').get();

    if (myDoc.exists && theirDoc.exists) {
      return myDoc.data['accepted'] && theirDoc.data['accepted'];
    }

    return false;
  }

  Future<bool> checkPendingRequest(String friendUid) async {
    final DocumentSnapshot myDoc = await _firestore
      .document('friends/$uid/list/$friendUid').get();
    final DocumentSnapshot theirDoc = await _firestore
      .document('friends/$friendUid/list/$uid').get();

    if (myDoc.exists && theirDoc.exists) {
      return !myDoc.data['accepted'] && !theirDoc.data['accepted'];
    }

    return false;
  }

  @override
  void dispose() {
    print('FriendsBloc disposed');
  }
}
