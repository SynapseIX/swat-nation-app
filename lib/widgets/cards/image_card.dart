import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

/// Creates a card that holds a single image fetched remotely.
class ImageCard extends StatelessWidget {
  const ImageCard({
    @required this.src,
    @required this.aspectRatio,
    Key key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  final String src;
  final double aspectRatio;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        margin: margin,
        padding: padding,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            color: Colors.grey,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: src,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
