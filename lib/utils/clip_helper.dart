import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:swat_nation/models/clip_info_model.dart';

/// Extract information from an XboxClips.com link.
/// 
/// Returns a decoded `ClipInfoModel` object with the clip's information.
Future<ClipInfoModel> extractClipInfo(String link) async {
  if (link == null || link.isEmpty) {
    return null;
  }

  if (link.startsWith('https://xboxclips.com/')) {
    final http.Response response = await http.get(link);
    final dom.Document document = parser.parse(response.body);

    final dom.Element video = document.getElementById('videoPlayer');
    final String thumbnail = video.attributes['poster'];
    final String videoUrl = video.children.first.attributes['src'];

    return ClipInfoModel(
      thumbnail: thumbnail,
      videoUrl: videoUrl,
      link: link,
    );
  }

  return null;
}
