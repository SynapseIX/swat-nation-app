import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/utils/device_model.dart';
import 'package:swat_nation/widgets/cards/art_card.dart';
import 'package:swat_nation/widgets/cards/news_card.dart';
import 'package:swat_nation/widgets/cards/tourney_card.dart';
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

    final double widthMultiplier = iPhoneX(context) ? 0.75 : 0.85;
    final double cardWidth = MediaQuery.of(context).size.width * widthMultiplier;

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
            cards: <Widget>[
              TourneyCard(
                src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.png?alt=media&token=1fd124d1-6ea8-4a1d-80e5-1b8274b230cb',
                width: cardWidth,
              ),
              TourneyCard(
                src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2318%20Bears%20Don\'t%20SWAT.png?alt=media&token=1f219fca-aed0-41ba-9a63-9f66b5d73628',
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

        // #swatisart
        CardSection(
          header: TextHeader(
            '#swatisart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            cards: const <Widget>[
              ArtCard(
                src: 'https://instagram.fuio1-1.fna.fbcdn.net/vp/ff67587a4391b3631be38a6451efb3a5/5DCE9C0C/t51.2885-15/e35/66643368_348677349143588_4294471077142937309_n.jpg?_nc_ht=instagram.fuio1-1.fna.fbcdn.net',
                title: 'Discover this week\'s art piece',
                latest: true,
              ),
              ArtCard(
                src: 'https://instagram.fuio1-1.fna.fbcdn.net/vp/d597da5de8367c86096e08c3aa1ed170/5DC96E35/t51.2885-15/e35/64512363_679881242458756_3019127877216873297_n.jpg?_nc_ht=instagram.fuio1-1.fna.fbcdn.net',
              ),
              ArtCard(
                src: 'https://instagram.fuio1-1.fna.fbcdn.net/vp/4ecba250bd68ab8a490520166394c662/5DD7BE5F/t51.2885-15/e35/62226051_119169212650113_1736816173290500060_n.jpg?_nc_ht=instagram.fuio1-1.fna.fbcdn.net',
              ),
              ArtCard(
                src: 'https://instagram.fuio1-1.fna.fbcdn.net/vp/c5c035ad46a6a1de1ca801e61d90548a/5DB5C211/t51.2885-15/e35/60992093_133834111145995_3306220303878915064_n.jpg?_nc_ht=instagram.fuio1-1.fna.fbcdn.net',
              ),
              ArtCard(
                src: 'https://instagram.fuio1-1.fna.fbcdn.net/vp/bfe8658a9c4cc957185c727a2cc26355/5DE8CF0F/t51.2885-15/e35/60445222_161679824865759_5397388580991524804_n.jpg?_nc_ht=instagram.fuio1-1.fna.fbcdn.net',
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
