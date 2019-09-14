import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/blocs/friends_bloc.dart';
import 'package:swat_nation/mixins/blocked_transformer.dart';
import 'package:swat_nation/models/blocked_model.dart';

class BlockedBloc extends BaseBloc with BlockedTransformer {
  BlockedBloc({
    @required this.uid,
  });

  final Firestore _firestore = Firestore.instance;
  final String uid;

  Stream<List<BlockedModel>> get allBlockedUsers => _firestore
    .collection('blocked/$uid/list')
    .snapshots()
    .transform(transformBlocked);
  
  Future<void> block(String otherUid) async {
    _firestore
      .collection('blocked/$uid/list')
      .document(otherUid)
      .setData(BlockedModel(dateBlocked: Timestamp.now()).toMap());
    
    final FriendsBloc friendsBloc = FriendsBloc(uid: uid);
    await friendsBloc.removeFriend(otherUid);
    friendsBloc.dispose();
  }

  Future<void> unblock(String otherUid) async {
    _firestore
      .document('blocked/$uid/list/$otherUid')
      .delete();
  }
  
  Future<bool> checkIfBlocked(String otherUid) async {
    final DocumentSnapshot doc = await _firestore.document('blocked/$otherUid/list/$uid').get();
    return doc.exists;
  }

   Future<bool> checkIfUserIsBlocked(String otherUid) async {
    final DocumentSnapshot doc = await _firestore.document('blocked/$uid/list/$otherUid').get();
    return doc.exists;
  }

  @override
  void dispose() {
    print('BlockedBloc disposed');
  }
}
