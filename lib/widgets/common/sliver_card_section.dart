import 'package:flutter/material.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Creates a section with a header and a horizontal card list.
class SliverCardSection extends StatelessWidget {
  const SliverCardSection({
    @required this.header,
    @required this.cardList,
  });
  
  final TextHeader header;
  final HorizontalCardList cardList;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header,
          cardList,
        ],
      ),
    );
  }
}
