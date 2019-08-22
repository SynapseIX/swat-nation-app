import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Creates a card for announcements.
class NewsCard extends StatelessWidget {
  const NewsCard({
    Key key,
    @required this.title,
    this.excerpt,
    this.thumbnailSrc,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.isNew = false,
    this.sliver = false,
  }) : super(key: key);

  final String title;
  final String excerpt;
  final String thumbnailSrc;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool isNew;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: const Color(0xFF333333),
          child: Stack(
            children: <Widget>[
              if (thumbnailSrc != null)
              CachedNetworkImage(
                imageUrl: thumbnailSrc,
                fadeInDuration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) {
                  return Center(child: const CircularProgressIndicator());
                },
              ),
              if (thumbnailSrc != null)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0,
                  ),
                  child: Container(color: Colors.black.withOpacity(0)),
                ),
              ),
              Container(color: Colors.black.withAlpha(96)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    if (excerpt != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        excerpt,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isNew)
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.red,
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
