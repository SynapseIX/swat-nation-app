import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/user_transformer.dart';
import 'package:swat_nation/models/user_model.dart';

/// BLoC that contains logic to manage users in Firestore.
class UserBloc extends BaseBloc with UserTransformer {
  final Firestore _firestore = Firestore.instance;
  final String userCollection = 'users';

  Stream<List<UserModel>> get allUsers => _firestore
    .collection(userCollection)
    .orderBy('displayName')
    .snapshots()
    .transform(userTransformer);
  
  Stream<List<UserModel>> allUsersWithDisplayName(String query) {
    return _firestore
      .collection(userCollection)
      .where('displayName', isGreaterThanOrEqualTo: query)
      .snapshots()
      .transform(userTransformer);
  } 

  Future<UserModel> userByUid(String uid) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(userCollection)
      .where('uid', isEqualTo: uid)
      .limit(1)
      .getDocuments();

    final List<DocumentSnapshot> docs = snapshot.documents;
    return docs.isNotEmpty
      ? UserModel.fromSnapshot(docs.first)
      : null;
  }

  Future<DocumentReference> create(UserModel model) {
    return _firestore
      .collection(userCollection)
      .add(model.toMap());
  }

  Future<void> update({
    @required String uid,
    @required Map<String, dynamic> data,
  }) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(userCollection)
      .where('uid', isEqualTo: uid)
      .limit(1)
      .getDocuments();
    
    final DocumentReference ref = snapshot.documents.first.reference;
    
    return ref.setData(
      data,
      merge: true,
    );
  }

  Future<bool> displayNameExists(String displayName) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(userCollection)
      .where('displayName', isEqualTo: displayName)
      .getDocuments();

    return snapshot.documents.isNotEmpty;
  }

  @override
  void dispose() {
    print('UserBloc disposed');
  }
}
