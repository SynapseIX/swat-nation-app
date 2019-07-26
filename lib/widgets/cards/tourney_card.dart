import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

/// Creates a card that represents a tourney.
class TourneyCard extends StatelessWidget {
  const TourneyCard({
    @required this.src,
    Key key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  final String src;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: Colors.grey,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: src,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
