import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/blocs/blocked_bloc.dart';
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
    final BlockedBloc blockedBloc = BlockedBloc(uid: uid);

    final bool blocked = await blockedBloc.checkIfBlocked(friendUid);
    final bool isPending = await checkPendingRequest(friendUid);

    if (blocked) {
      blockedBloc.dispose();
      throw 'This friend request can\'t be sent.';
    }

    if (isPending) {
      throw 'There\'s still a pending friend request with this user.';
    }

    await _firestore
      .collection('friends/$uid/list')
      .document(friendUid)
      .setData(FriendModel(incoming: false).toMap());

    await _firestore
      .collection('friends/$friendUid/list')
      .document(uid)
      .setData(FriendModel(incoming: true).toMap());
  }

  Future<void> processFriendRequest(String friendUid, bool accepted) async {
    final DocumentReference myRef = _firestore.document('friends/$uid/list/$friendUid');
    final DocumentReference theirRef = _firestore.document('friends/$friendUid/list/$uid');

    if (accepted) {
      final Map<String, dynamic> data = <String, dynamic>{
        'accepted': true,
        'dateAdded': Timestamp.now(),
      };
      
      await myRef.updateData(data);
      await theirRef.updateData(data);
    } else {
      removeFriend(friendUid);
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
