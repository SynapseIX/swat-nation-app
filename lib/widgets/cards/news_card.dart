import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/models/announcement_model.dart';
import 'package:swat_nation/utils/url_launcher.dart';

/// Creates a card for announcements.
class NewsCard extends StatelessWidget {
  const NewsCard({
    Key key,
    @required this.model,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = 356.0,
    this.height = double.infinity,
    this.isNew = false,
    this.sliver = false,
  }) : super(key: key);

  final AnnouncementModel model;
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
      child: GestureDetector(
        onTap: () => openUrl(model.link, true),
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            color: const Color(0xFF333333),
            child: Stack(
              children: <Widget>[
                if (model.thumbnail != null)
                CachedNetworkImage(
                  imageUrl: model.thumbnail,
                  fadeInDuration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                if (model.thumbnail != null)
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
                        model.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                      if (model.excerpt != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          model.excerpt,
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
                if (model.isNew)
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
      ),
    );
    
    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
