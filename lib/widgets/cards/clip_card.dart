import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Creates a card that represents a clip.
class ClipCard extends StatelessWidget {
  const ClipCard({
    @required this.src,
    @required this.duration,
    @required this.author,
    Key key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.sliver = false,
  }) : super(key: key);

  final String src;
  final String duration;
  final String author;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            color: Colors.grey,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: src,
                    fadeInDuration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) {
                      return Center(child: const CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 80.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        size: 15.0,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        duration,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: Text(
                    author,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}