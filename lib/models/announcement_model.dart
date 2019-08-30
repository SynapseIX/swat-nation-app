import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an announcement instance.
class AnnouncementModel extends BaseModel {
  AnnouncementModel({
    @required this.title,
    @required this.link,
    this.excerpt,
    this.thumbnail,
    this.isNew = false,
  });

  AnnouncementModel.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot.data['title'];
    link = snapshot.data['link'];
    excerpt = snapshot.data['excerpt'];
    thumbnail = snapshot.data['thumbnail'];
    isNew = snapshot.data['isNew'];
  }

  String title;
  String excerpt;
  String link;
  bool isNew;
  String thumbnail;

  @override
  String toString() {
    return '''
    title: $title
    excerpt: $excerpt
    link: $link
    isNew: $isNew
    thumbnail: $thumbnail
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'excerpt': excerpt,
      'link': link,
      'isNew': isNew,
      'thumbnail': thumbnail,
    };
  }
}
