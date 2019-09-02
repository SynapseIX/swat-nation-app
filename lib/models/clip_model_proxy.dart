import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an XboxClips.com clip information.
class ClipModelProxy extends BaseModel {
  ClipModelProxy({
    @required this.thumbnail,
    @required this.videoUrl,
    @required this.link,
    this.title,
    this.author,
  });

  ClipModelProxy.blank();

  String thumbnail;
  String videoUrl;
  String link;
  String title;
  String author;

  @override
  String toString() {
    return '''
    thumbnail: $thumbnail
    videoUrl: $videoUrl
    link: $link
    title: $title
    author: $author
    ''';
  }
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'link': link,
      'title': title,
      'author': author,
    };
  }
}
