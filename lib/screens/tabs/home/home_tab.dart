import 'package:flutter/material.dart';
import 'package:swat_nation/widgets/cards/image_card.dart';

/// Represents the home tab screen.
class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: const Text('Welcome to SWAT Nation'),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            const ImageCard(
              aspectRatio: 16.0 / 9.0,
              src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.png?alt=media&token=1fd124d1-6ea8-4a1d-80e5-1b8274b230cb',
              margin: EdgeInsets.all(8.0),
            ),
          ]),
        ),
      ],
    );
  }
}
