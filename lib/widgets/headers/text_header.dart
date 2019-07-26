import 'package:flutter/cupertino.dart';

/// Creates a text header.
class TextHeader extends StatelessWidget {
  const TextHeader(
    this.text, {
    Key key,
    this.style,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.sliver = false,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget header = Container(
      margin: margin,
      padding: padding,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
      ),
    );

    return sliver ? SliverToBoxAdapter(child: header): header;
  }
}
