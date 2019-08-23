import 'package:flutter/cupertino.dart';

/// Creates a text header.
class TextHeader extends StatelessWidget {
  const TextHeader(
    this.text, {
    Key key,
    this.actions = const <Widget>[],
    this.style = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
    ),
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.margin = const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
    this.padding = EdgeInsets.zero,
    this.sliver = false,
  }) : super(key: key);

  final String text;
  final List<Widget> actions;
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
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: style,
            textAlign: textAlign,
            overflow: overflow,
          ),
          Spacer(),
          if (actions.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          ),
        ],
      ),
    );

    return sliver ? SliverToBoxAdapter(child: header): header;
  }
}
