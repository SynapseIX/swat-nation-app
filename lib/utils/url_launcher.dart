import 'package:url_launcher/url_launcher.dart';

Future<bool> openURL(String url) async {
  if (url == null || url.isEmpty) {
    return false;
  }

  final String encodedURL = Uri.encodeFull(url);

  if (await canLaunch(encodedURL)) {
    return launch(encodedURL);
  } else {
    throw 'Could not launch $url';
  }
}
