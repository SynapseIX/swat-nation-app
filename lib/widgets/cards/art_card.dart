import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Creates a card that represents an art piece.
class ArtCard extends StatelessWidget {
  const ArtCard({
    @required this.src,
    Key key,
    this.title,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.latest = false,
    this.sliver = false,
  }) : super(key: key);

  final String src;
  final String title;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool latest;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = AspectRatio(
      aspectRatio: 1.0,
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
                CachedNetworkImage(
                  imageUrl: src,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (BuildContext context, String url) {
                    return Center(child: const CircularProgressIndicator());
                  },
                ),
                if (latest)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Container(color: Colors.black.withOpacity(0)),
                  ),
                ),
                if (latest || title != null)
                Container(color: Colors.black.withAlpha(96)),
                if (title != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
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
