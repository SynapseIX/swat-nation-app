import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/models/achievement_model.dart';

/// Represents an achievement card.
class AchievementCard extends StatelessWidget {
  const AchievementCard({
    Key key,
    @required this.model,
    @required this.uid,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.sliver = false,
  }) : super(key: key);
  
  final AchievementModel model;
  final String uid;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = AspectRatio(
      aspectRatio: 3.0 / 4.0,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          child: CachedNetworkImage(
            imageUrl: model.badge,
            fadeInDuration: const Duration(milliseconds: 300),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
