import 'package:flutter/material.dart';

/// Creates an horizontal card list.
class HorizontalCardList extends StatelessWidget {
  const HorizontalCardList({
    @required this.cards,
    @required this.height,
    Key key,
    this.padding = const EdgeInsets.all(8.0),
  }) : assert(height > 0.0),
       super(key: key);

  final List<Widget> cards;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }
}
