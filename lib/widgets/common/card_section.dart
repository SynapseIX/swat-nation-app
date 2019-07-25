import 'package:flutter/material.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Creates a section with a header and a horizontal card list.
class CardSection extends StatelessWidget {
  const CardSection({
    @required this.header,
    @required this.cardList,
    this.sliver = false,
  });
  
  final TextHeader header;
  final HorizontalCardList cardList;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final Widget section = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        header,
        cardList,
      ],
    );

    return sliver ? SliverToBoxAdapter(child: section) : section;
  }
}
