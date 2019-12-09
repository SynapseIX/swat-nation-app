import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';

/// Screen that allows to visualize a standalone network image.
class ImageViewer extends StatefulWidget {
  const ImageViewer({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);
  
  final String imageUrl;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final List<int> bytes = base64.decode(parameters['url'].first);
        final String decodedUrl = utf8.decode(bytes);
        return ImageViewer(imageUrl: decodedUrl);
      }
    );
  }

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ],
    );
    // TODO(itsprof): make native call to restore portrait
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: Center(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
                loadingChild: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  MdiIcons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
