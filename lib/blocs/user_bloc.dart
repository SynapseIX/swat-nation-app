import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/models/user_model.dart';

/// BLoC that contains logic to manage users in Firestore.
class UserBloc extends BaseBloc {
  final Firestore _firestore = Firestore.instance;
  final String collection = 'users';

  Stream<QuerySnapshot> get allUsers => _firestore.collection(collection).snapshots();

  Future<DocumentSnapshot> userByUid(String uid) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(collection)
      .where('uid', isEqualTo: uid)
      .getDocuments();

    final List<DocumentSnapshot> docs = snapshot.documents;
    return docs.isNotEmpty
      ? docs.first
      : null;
  }

  Future<DocumentReference> create(UserModel model) async {
    return _firestore
      .collection(collection)
      .add(model.toMap());
  }

  Future<void> update({
    @required String uid,
    @required Map<String, dynamic> data,
  }) async {
    final DocumentSnapshot doc = await userByUid(uid);
    final DocumentReference ref = doc.reference;
    
    return ref.setData(
      data,
      merge: true,
    );
  }

  Future<bool> displayNameExists(String displayName) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(collection)
      .where('displayName', isEqualTo: displayName)
      .getDocuments();

    return snapshot.documents.isNotEmpty;
  }

  @override
  void dispose() {
    print('UserBloc disposed');
  }
}
