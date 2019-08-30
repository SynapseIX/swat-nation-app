import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a SWAT is art instance.
class SwatArtModel extends BaseModel {
  SwatArtModel({
    @required this.link,
    @required this.thumbnail,
    this.latest = false,
  });

  SwatArtModel.fromSnapshot(DocumentSnapshot snapshot) {
    link = snapshot.data['link'];
    thumbnail = snapshot.data['thumbnail'];
    latest = snapshot.data['latest'];
  }

  String link;
  String thumbnail;
  bool latest;

  @override
  String toString() {
    return '''
    link: $link
    thumbnail: $thumbnail
    link: $link
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'thumbnail': thumbnail,
      'latest': latest,
    };
  }
}
