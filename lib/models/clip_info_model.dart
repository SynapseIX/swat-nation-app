import 'package:flutter/foundation.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents an XboxClips.com clip information.
class ClipInfoModel extends BaseModel {
  ClipInfoModel({
    @required this.thumbnail,
    @required this.videoUrl,
  });

  String thumbnail;
  String videoUrl;

  @override
  String toString() {
    return '''
    thumbnail: $thumbnail
    videoUrl: $videoUrl
    ''';
  }
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
    };
  }
}
