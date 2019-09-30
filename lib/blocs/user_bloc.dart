import 'package:cloud_firestore/cloud_firestore.dart';
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
  
  Stream<List<UserModel>> get monthlyRanking => _firestore
    .collection(userCollection)
    .orderBy('monthlyScore', descending: true)
    .snapshots()
    .transform(userTransformer);

  Future<UserModel> userByUid(String uid) async {
    try {
      final DocumentSnapshot snapshot = await _firestore
        .collection(userCollection)
        .document(uid)
        .snapshots()
        .first;
      
      return UserModel.fromSnapshot(snapshot);
    } catch (e) {
      return null;
    }
  }

  Future<void> create(UserModel model) {
    return _firestore
      .collection(userCollection)
      .document(model.uid)
      .setData(model.toMap());
  }

  Future<void> update(UserModel user) async {
    return _firestore
      .collection(userCollection)
      .document(user.uid)
      .updateData(user.toMap());
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
