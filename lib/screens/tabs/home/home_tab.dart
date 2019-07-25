import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/utils/device_model.dart';
import 'package:swat_nation/widgets/cards/image_card.dart';
import 'package:swat_nation/widgets/cards/news_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/view_all_card.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Represents the home tab screen.
class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;
    final double cardHeight = iPhoneX(context) ? 230 : 210;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: const Text('What\'s New?'),
        ),

        // Upcoming Tournaments
        CardSection(
          header: TextHeader(
            'Upcoming\nTournaments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            height: cardHeight,
            cards: <Widget>[
              ImageCard(
                'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.png?alt=media&token=1fd124d1-6ea8-4a1d-80e5-1b8274b230cb',
                width: cardWidth,
              ),
              ImageCard(
                'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2318%20Bears%20Don\'t%20SWAT.png?alt=media&token=1f219fca-aed0-41ba-9a63-9f66b5d73628',
                width: cardWidth,
              ),
              ViewAllCard(
                onTap: () => TabBarBloc.instance().setCurrentIndex(1),
              ),
            ],
          ),
          sliver: true,
        ),

        // Latest News
        CardSection(
          header: TextHeader(
            'Latest News',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            height: cardHeight,
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
          sliver: true,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
