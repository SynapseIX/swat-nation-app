import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_model_proxy.dart';

/// Extract information from an XboxClips.com link.
/// 
/// Returns a decoded `ClipModelProxy` object with the clip's information.
Future<ClipModelProxy> extractClipInfo(String link) async {
  if (link == null || link.isEmpty) {
    return null;
  }

  if (link.startsWith(kXboxClipsHost)) {
    final http.Response response = await http.get(link);

    if (response.statusCode != 200) {
      throw '[${response.statusCode}] Error getting clip from XboxClips.com';
    }

    final dom.Document document = parser.parse(response.body);
    final dom.Element video = document.getElementById('videoPlayer');
    final String thumbnail = video.attributes['poster'];
    final String videoUrl = video.children.first.attributes['src'];

    return ClipModelProxy(
      thumbnail: thumbnail,
      videoUrl: videoUrl,
      link: link,
    );
  }

  return null;
}
