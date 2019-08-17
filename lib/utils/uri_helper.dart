/// Extract the video URL from an XboxDVR.com clip download URL.
/// 
/// Returns a decoded `String` with the video file location.
String getXboxDvrVideoUrl(String downloadUrl) {
  final String videoUrl = downloadUrl.replaceAll(
    'https://gamerdvr.com/xbox/load/video/',
    '',
  );

  final String decodedPart = Uri.decodeComponent(videoUrl);
  return decodedPart.endsWith('.mp4')
    ? decodedPart.substring(0, decodedPart.length - 4)
    : decodedPart;
}
