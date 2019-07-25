import 'package:flutter/material.dart';
import 'package:swat_nation/widgets/cards/image_card.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

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
          title: const Text('What\'s New?'),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              //Upcoming Tournaments
              TextHeader(
                'Upcoming\nTournaments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
                margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              ),
              HorizontalCardList(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  ImageCard(
                    src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.png?alt=media&token=1fd124d1-6ea8-4a1d-80e5-1b8274b230cb',
                    aspectRatio: 16.0 / 9.0,
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  ),
                  ImageCard(
                    src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2318%20Bears%20Don\'t%20SWAT.png?alt=media&token=1f219fca-aed0-41ba-9a63-9f66b5d73628',
                    aspectRatio: 16.0 / 9.0,
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
