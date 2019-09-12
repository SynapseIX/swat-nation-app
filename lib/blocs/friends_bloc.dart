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
    .orderBy('pending', descending: true)
    .snapshots()
    .transform(transformFriends);

  Stream<List<FriendModel>> get acceptedFriends => _firestore
    .collection('users/$uid/friends')
    .where('pending', isEqualTo: false)
    .snapshots()
    .transform(transformFriends);

  Stream<List<FriendModel>> get pendingFriends => _firestore
    .collection('users/$uid/friends')
    .where('pending', isEqualTo: true)
    .snapshots()
    .transform(transformFriends);
  
  Future<bool> sendFriendRequest(String friendUid) async {
    final DocumentReference outgoingRequest = await _firestore
      .collection('users/$uid/friends')
      .add(FriendModel(uid: friendUid, outgoing: true, dateAdded: Timestamp.now()).toMap());
    
    final DocumentReference incomingRequest = await _firestore
      .collection('users/$friendUid/friends')
      .add(FriendModel(uid: uid, outgoing: false, dateAdded: Timestamp.now(),).toMap());

    if (outgoingRequest == null || incomingRequest == null) {
      throw 'Could not send the friend request.';
    }

    return true;
  }

  Future<bool> processFriendRequest(FriendModel request, bool accept) async {
    final QuerySnapshot incomingRequest = await _firestore
      .collection('users/$uid/friends')
      .where('uid', isEqualTo: request.uid)
      .snapshots()
      .first;
    final DocumentReference incomingRef = incomingRequest.documents.first.reference;

    final QuerySnapshot outgoingRequest = await _firestore
      .collection('users/${request.uid}/friends')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .first;
    final DocumentReference outgoingRef = outgoingRequest.documents.first.reference;

    if (accept) {
      final Map<String, dynamic> acceptRequest = <String, dynamic>{
        'pending': accept,
      };

      await incomingRef.updateData(acceptRequest);
      await outgoingRef.updateData(acceptRequest);

      return true;
    } else {
      await incomingRef.delete();
      await outgoingRef.delete();

      return false;
    }
  }

  Future<bool> removeFriend(FriendModel friend) async {
    final QuerySnapshot incomingRequest = await _firestore
      .collection('users/$uid/friends')
      .where('uid', isEqualTo: friend.uid)
      .snapshots()
      .first;
    final DocumentReference incomingRef = incomingRequest.documents.first.reference;

    final QuerySnapshot outgoingRequest = await _firestore
      .collection('users/${friend.uid}/friends')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .first;
    final DocumentReference outgoingRef = outgoingRequest.documents.first.reference;

    await incomingRef.delete();
    await outgoingRef.delete();

    return true;
  }

  Future<bool> checkFriendship(String friendUid) async {
    final List<FriendModel> friends = await allFriends.first;
    return friends?.firstWhere((FriendModel model) => model.uid == friendUid) != null;
  }

  @override
  void dispose() {
    print('FriendsBloc disposed');
  }
}
