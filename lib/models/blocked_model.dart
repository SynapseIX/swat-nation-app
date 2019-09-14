import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an instance of a blocked user.
class BlockedModel extends BaseModel {
  BlockedModel({
    this.uid,
    this.dateBlocked,
  });

  BlockedModel.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.reference.documentID;
    dateBlocked = snapshot.data['dateBlocked'];
  }

  String uid;
  Timestamp dateBlocked;

  @override
  String toString() {
    return '''
    uid: $uid
    dateBlocked: $dateBlocked
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateBlocked': dateBlocked,
    };
  }
}
