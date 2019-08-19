import 'package:flutter/material.dart';
import 'package:swat_nation/models/clip_model.dart';

/// Creates a card that represents a clip.
class ClipCard extends StatelessWidget {
  const ClipCard({
    Key key,
    @required this.model,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.sliver = false,
  }) : super(key: key);

  final ClipModel model;
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
          // TODO(itsprof): implement video player
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
