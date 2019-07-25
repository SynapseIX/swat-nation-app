import 'package:flutter/material.dart';
import 'package:swat_nation/utils/device_model.dart';
import 'package:swat_nation/widgets/cards/image_card.dart';
import 'package:swat_nation/widgets/cards/news_card.dart';
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
    final double cardListHeightMultiplier = iPhoneX(context) ? 0.25 : 0.3;
    final double cardListHeight = MediaQuery.of(context).size.height * cardListHeightMultiplier;

    final double cardWidth = MediaQuery.of(context).size.width * 0.85;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: const Text('What\'s New?'),
        ),

        // Upcoming Tournaments
        _SliverCardSection(
          header: TextHeader(
            'Upcoming\nTournaments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            height: cardListHeight,
            cards: <Widget>[
              ImageCard(
                'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.png?alt=media&token=1fd124d1-6ea8-4a1d-80e5-1b8274b230cb',
                width: cardWidth,
              ),
              ImageCard(
                'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2318%20Bears%20Don\'t%20SWAT.png?alt=media&token=1f219fca-aed0-41ba-9a63-9f66b5d73628',
                width: cardWidth,
              ),
            ],
          ),
        ),

        // Latest News
        _SliverCardSection(
          header: TextHeader(
            'Latest News',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            height: cardListHeight,
            cards: <Widget>[
              NewsCard(
                title: 'New App Launched',
                excerpt: 'We\'ve launched our new mobile app, and we\'re so excited about it! This is your new Swiss Army knife for all your SWAT needs.',
                thumbnailSrc: 'https://content.halocdn.com/media/Default/community/blogs/Infinite/hi_stinger_hologramexplosion_wtrmk-70aef8e8f5654444be45072bed746709.jpg',
                width: cardWidth,
                isNew: true,
              ),
              NewsCard(
                title: 'Tournament Rules',
                excerpt: 'These are the rules that we’ve set for ANY tournament hosted by SWAT Nation. Knowledge is power.',
                thumbnailSrc: 'https://content.halocdn.com/media/Default/community/blogs/3840_haloinfinite_e318_ring-96bf71d241184bfb8b1f1b0c3bb8a1a0.png',
                width: cardWidth,
              ),
              NewsCard(
                title: 'Tips For New Streamers',
                excerpt: 'Prof discusses what, from his experience, is needed to grow a successful channel on Twitch or any other streaming platform.',
                width: cardWidth,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Creates a section with a header and a horizontal card list.
class _SliverCardSection extends StatelessWidget {
  const _SliverCardSection({
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
