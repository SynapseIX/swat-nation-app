import 'package:flutter/material.dart';

/// Creates an horizontal card list.
class HorizontalCardList extends StatelessWidget {
  const HorizontalCardList({
    @required this.children,
    @required this.height,
    this.padding = EdgeInsets.zero,
  }) : assert(height > 0.0);

  final List<Widget> children;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }
}
