import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

/// Creates a card that represents a tourney.
class TourneyCard extends StatelessWidget {
  const TourneyCard({
    @required this.src,
    Key key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = 356.0,
    this.height = 200.0,
    this.sliver = false,
  }) : super(key: key);

  final String src;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget card = Card(
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFF333333),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: src,
          fit: BoxFit.fill,
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card): card;
  }
}
