import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        child: CachedNetworkImage(
          imageUrl: src,
          fadeInDuration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
          placeholder: (BuildContext context, String url) {
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card): card;
  }
}
