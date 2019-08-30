import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/models/swat_art_model.dart';
import 'package:swat_nation/utils/url_launcher.dart';

/// Creates a card that represents an art piece.
class ArtCard extends StatelessWidget {
  const ArtCard({
    Key key,
    @required this.model,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.sliver = false,
  }) : super(key: key);

  final SwatArtModel model;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: () => openUrl(model.link),
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
                    imageUrl: model.thumbnail,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (BuildContext context, String url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  if (model.latest)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0,
                        sigmaY: 10.0,
                      ),
                      child: Container(color: Colors.black.withOpacity(0)),
                    ),
                  ),
                  if (model.latest)
                  Container(color: Colors.black.withAlpha(96)),
                  if (model.latest)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      'Discover this week\'s art piece by Zombie AZF',
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
      ),
    );
    
    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
