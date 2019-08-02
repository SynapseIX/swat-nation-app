import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/models/user_model.dart';

/// BLoC that contains logic to manage users in Firestore.
class UserBloc extends BaseBloc {
  final Firestore _firestore = Firestore.instance;
  final String collection = 'users';

  Stream<QuerySnapshot> get allUsers => _firestore.collection(collection).snapshots();

  Future<UserModel> userByUid(String uid) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(collection)
      .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    
    try {
      final DocumentSnapshot document = documents.singleWhere(
        (DocumentSnapshot snapshot) => snapshot.data['uid'] == uid,
      );

      return UserModel.documentSnapshot(document);
    } catch (e) {
      return null;
    }
  }

  Future<DocumentReference> createUser(UserModel model) async {
    return _firestore
      .collection(collection)
      .add(model.toMap());
  }

  Future<void> updateUser(UserModel model) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(collection)
      .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;

    final DocumentSnapshot document = documents.singleWhere(
      (DocumentSnapshot snapshot) => snapshot.data['uid'] == model.uid,
    );

    return _firestore
      .collection(collection)
      .document(document.documentID)
      .setData(model.toMap());
  }

  Future<bool> displayNameExists(String displayName) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(collection)
      .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;

    if (documents.isEmpty) {
      return false;
    }

    try {
      return documents.singleWhere(
        (DocumentSnapshot snapshot) => snapshot.data['displayName'] == displayName,
      ).exists;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    print('UserBloc disposed');
  }
}
