import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(String url) async {
  if (url == null || url.isEmpty) {
    return false;
  }

  final String encodedUrl = Uri.encodeFull(url);

  if (await canLaunch(encodedUrl)) {
    return launch(
      encodedUrl,
      forceSafariVC: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}
