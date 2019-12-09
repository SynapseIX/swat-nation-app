import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/announcements_bloc.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/blocs/swat_art_bloc.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/announcement_model.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/swat_art_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/device_model.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/art_card.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/cards/news_card.dart';
import 'package:swat_nation/widgets/cards/tourney_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/view_all_card.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Represents the home tab screen.
class HomeTab extends StatefulWidget implements BaseTab {
  const HomeTab({ Key key }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();

  @override
  IconData get icon => MdiIcons.home;

  @override
  String get title => 'Home';
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  UserBloc userBloc;
  ClipsBloc clipsBloc;
  AnnouncementsBloc announcementsBloc;
  SwatArtBloc artBloc;

  @override
  void initState() {
    final int seed = Random(DateTime.now().millisecondsSinceEpoch)
      .nextInt(kMaxRandomValue);

    userBloc = UserBloc();
    
    clipsBloc = ClipsBloc();
    clipsBloc.fetchRandomClip(seed);

    announcementsBloc = AnnouncementsBloc();
    artBloc = SwatArtBloc();

    super.initState();
  }

  @override
  void dispose() {
    userBloc.dispose();
    clipsBloc.dispose();
    announcementsBloc.dispose();
    artBloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double widthMultiplier = iPhoneX(context) ? 0.75 : 0.85;
    final double cardWidth = MediaQuery.of(context).size.width * widthMultiplier;

    return CustomScrollView(
      slivers: <Widget>[
        _AppBar(userBloc: userBloc),

        // TODO(itsprof): implement
        // Upcoming Tournaments
        CardSection(
          header: const TextHeader('Upcoming\nTournaments'),
          cardList: HorizontalCardList(
            cards: <Widget>[
              TourneyCard(
                src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2317%20Once%20upon%20a%20SWAT.jpg?alt=media&token=58f286a3-fd53-48fc-92c4-b53b4a37df56',
                width: cardWidth,
              ),
              TourneyCard(
                src: 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/tourney-posters%2F%2318%20Bears%20Don\'t%20SWAT.jpg?alt=media&token=5dcf559d-9a1f-4bc3-90a3-7ad88de9d65b',
                width: cardWidth,
              ),
              ViewAllCard(
                onTap: () => TabBarBloc.instance().controller.jumpToPage(1),
              ),
            ],
          ),
          sliver: true,
        ),

        // Community Highlight
        StreamBuilder<ClipModel>(
          stream: clipsBloc.randomClipStream,
          builder: (BuildContext context, AsyncSnapshot<ClipModel> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const SliverToBoxAdapter(child: SizedBox());
            }

            return SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  const TextHeader('Community\nHighlight'),
                  ClipCard(
                    model: snapshot.data,
                    margin: const EdgeInsets.all(8.0),
                  ),
                ],
              ),
            );
          },
        ),

        // Announcements
        StreamBuilder<List<AnnouncementModel>>(
          stream: announcementsBloc.latest,
          builder: (BuildContext context, AsyncSnapshot<List<AnnouncementModel>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const SliverToBoxAdapter(child: SizedBox());
            }

            final Widget Function(AnnouncementModel) cardMapper = (AnnouncementModel model) {
                return NewsCard(
                  key: UniqueKey(),
                  model: model,
                  width: cardWidth,
                );
            };

            final List<Widget> cards = snapshot
              .data
              .map(cardMapper)
              .toList()
              ..add(ViewAllCard(
                onTap: () => openUrl('https://swatnation.net/community'),
              ));

            return CardSection(
              header: const TextHeader('Announcements'),
              cardList: HorizontalCardList(
                cards: cards,
              ),
              sliver: true,
            );
          },
        ),

        // #swatisart
        StreamBuilder<List<SwatArtModel>>(
          stream: artBloc.latest,
          builder: (BuildContext context, AsyncSnapshot<List<SwatArtModel>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const SliverToBoxAdapter(child: SizedBox());
            }

            final Widget Function(SwatArtModel) cardMapper = (SwatArtModel model) {
                return ArtCard(
                  key: UniqueKey(),
                  model: model,
                  width: cardWidth,
                );
            };

            final List<Widget> cards = snapshot
              .data
              .map(cardMapper)
              .toList()
              ..add(ViewAllCard(
                onTap: () => openUrl(kInstagram),
              ));

            return CardSection(
              header: const TextHeader('#swatisart'),
              cardList: HorizontalCardList(
                cards: cards,
              ),
              sliver: true,
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key key,
    @required this.userBloc
  }) : super(key: key);
  
  final UserBloc userBloc;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: AuthBloc.instance().onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          final String loadingDisplayName = snapshot.data.displayName ?? '...';
          final String displayName =
            loadingDisplayName.length > kDisplayNameMaxChararcters
            ? '${loadingDisplayName.substring(0, kDisplayNameMaxChararcters - 5)}...'
            : loadingDisplayName;

          return SliverAppBar(
            pinned: true,
            floating: true,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () async {
                DialogHelper.instance().showWaitingDialog(
                  context: context,
                  title: 'Fetching profile...',
                );
                
                final FirebaseUser user = await AuthBloc.instance().currentUser;

                Navigator.pop(context);
                Routes.router.navigateTo(context, '/profile/${user.uid}/${user.uid}');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data.photoUrl ?? kDefaultAvi,
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                      ),
                    ),
                  ),
                  Text(
                    'Hi, $displayName!',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverAppBar(
          pinned: true,
          floating: true,
          automaticallyImplyLeading: false,
          title: const Text('What\'s New?'),
        );
      },
    );
  }
}
