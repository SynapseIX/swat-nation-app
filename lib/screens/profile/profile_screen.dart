import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/achievements_bloc.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/achievement_card.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/common/view_all_card.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Represents the user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key key,
    @required this.model,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final UserBloc bloc = UserBloc();
        final String uid = parameters['uid'].first;

        return FutureBuilder<UserModel>(
          future: bloc.userByUid(uid),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            return ProfileScreen(model: snapshot.data);
          },
        );
      }
    );
  }
  
  final UserModel model;

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AchievementsBloc achievementsBloc;
  ClipsBloc clipsBloc;
  UserModel user;

  @override
  void initState() {
    achievementsBloc = AchievementsBloc(uid: widget.model.uid);
    clipsBloc = ClipsBloc();
    user = widget.model;
    super.initState();
  }

  @override
  void dispose() {
    achievementsBloc.dispose();
    clipsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: AuthBloc.instance().currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        final bool me = snapshot.hasData && user.uid == snapshot.data.uid;

        return Scaffold(
          appBar: AppBar(
            title: me
              ? const Text('My Profile')
              : const Text('Member Profile'),
            leading: IconButton(
              icon: const Icon(MdiIcons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
              if (me)
              IconButton(
                icon: const Icon(MdiIcons.accountEdit),
                tooltip: 'Edit Profile',
                onPressed: () => _navigateToEdit(),
              ),
              if (!me)
              IconButton(
                icon: const Icon(MdiIcons.alert),
                tooltip: 'Report User',
                // TODO(itsprof): implement report user
                onPressed: () {},
              ),
            ]
          ),
          body: me || !user.private
            ? _PublicBody(
                achievementsBloc: achievementsBloc,
                clipsBloc: clipsBloc,
                user: user,
                me: me,
              )
            : _PrivateBody(user: user),
        );
      },
    );
  }

  Future<void> _navigateToEdit() async {
    final UserModel updatedUser = await Routes
      .router
      .navigateTo(context, 'profile/edit/${user.uid}');

    if (updatedUser != null) {
      setState(() {
        user = updatedUser;
      });
    }
  }
}

class _PublicHeader extends StatelessWidget {
  const _PublicHeader({
    @required this.user,
    this.me = false,
  });

  final UserModel user;
  final bool me;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            user.headerUrl ?? kDefaultProfileHeader,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.black54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3.0,
                      color: Colors.white,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: CachedNetworkImage(
                      imageUrl: user.photoUrl ?? kDefaultAvi,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          user.displayName.length > 15
                            ? '${user.displayName.substring(0, 10)}...'
                            : user.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.verified)
                        const VerifiedBadge(
                          margin: EdgeInsets.only(left: 4.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Joined ${humanizeTimestamp(user.createdAt, 'MMMM yyyy')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          MdiIcons.heart,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${user.score}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (user.bio != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                user.bio,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            if (me)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: user.uid));
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: const Text('Your Support ID has been copied.'),
                  ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16.0),
                    child: const Text(
                      'Support ID:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      user.uid,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivateHeader extends StatelessWidget {
  const _PrivateHeader({
    @required this.user,
  });

  final UserModel user;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: CachedNetworkImageProvider(user.headerUrl ?? kDefaultProfileHeader),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0x88000000),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              shape: BoxShape.circle,
              border: Border.all(
                width: 3.0,
                color: Colors.white,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: CachedNetworkImage(
                imageUrl: user.photoUrl ?? kDefaultAvi,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                user.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.verified)
              const VerifiedBadge(
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PublicBody extends StatelessWidget {
  const _PublicBody({
    @required this.achievementsBloc,
    @required this.clipsBloc,
    @required this.user,
    this.me = false,
  });

  final AchievementsBloc achievementsBloc;
  final ClipsBloc clipsBloc;
  final UserModel user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // Profile header
        _PublicHeader(user: user, me: me),

        // Socials
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16.0,
            runSpacing: 4.0,
            children: <Widget>[
              if (user.gamertag != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.xbox),
                label: Text(user.gamertag),
                onPressed: () => openUrl('$kGamertag${user.gamertag}'),
              ),

              if (user.twitter != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.twitter),
                label: Text(user.twitter),
                onPressed: () => openUrl('https://twitter.com/${user.twitter}'),
              ),

              if (user.instagram != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.instagram),
                label: Text(user.instagram),
                onPressed: () => openUrl('https://instagram.com/${user.instagram}'),
              ),

              if (user.facebook != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.facebook),
                label: Text(user.facebook),
                onPressed: () => openUrl('https://facebook.com/${user.facebook}'),
              ),

              if (user.mixer != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.mixer),
                label: Text(user.mixer),
                onPressed: () => openUrl('https://mixer.com/${user.mixer}'),
              ),

              if (user.twitch != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.twitch),
                label: Text(user.twitch),
                onPressed: () => openUrl('https://twitch.tv/${user.twitch}'),
              ),
            ],
          ),
        ),

        if (me && user.provider == UserProvider.email)
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: const Text(
                    'Change Email',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () async {
                    final Object error = await Routes
                      .router
                      .navigateTo(context, Routes.changeEmail);

                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: error == null
                          ? const Text('Your email was successfully changed.')
                          : Text('$error'),
                    ));
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: RaisedButton(
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                  // TODO(itsprof): implement
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        // Custom logo request
        if (me)
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: RaisedButton(
            // TODO(itsprof): implement
            onPressed: () {},
            child: const Text('Request Custom Logo'),
          ),
        ),

        // Achievements
        StreamBuilder<List<AchievementModel>>(
          stream: achievementsBloc.unlockedAchievements,
          builder:
            (BuildContext context, AsyncSnapshot<List<AchievementModel>> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final Widget Function(AchievementModel) cardMapper = (AchievementModel model) {
                return AchievementCard(
                  key: UniqueKey(),
                  model: model,
                  uid: user.uid,
                );
              };

              final bool largeList = snapshot.data.length > kMaxAchievementCards;
              final List<Widget> cards = largeList
                ? snapshot.data
                  .sublist(0, kMaxAchievementCards)
                  .map(cardMapper).toList()
                : snapshot.data
                  .map(cardMapper).toList();

              if (cards.length > kMaxAchievementCards) {
                cards.add(ViewAllCard(
                  onTap: () => Routes
                    .router
                    .navigateTo(context, '/achievements/${user.uid}/$me'),
                ));
              }

              return CardSection(
                header: const TextHeader('Achievements'),
                cardList: HorizontalCardList(
                  cards: cards,
                ),
              );
            },
        ),

        // Clips
        StreamBuilder<List<ClipModel>>(
          stream: clipsBloc.allClipsForUser(user.uid),
          builder: (BuildContext context, AsyncSnapshot<List<ClipModel>> snapshot) {
            final Widget Function(ClipModel) cardMapper = (ClipModel model) {
              return ClipCard(
                key: ValueKey<String>(model.uid),
                model: model,
              );
            };

            // TODO(itsprof): validate if subscriber
            const bool subscriber = true;
            Widget clipsContent;
            int numberOfClips = 0;

            if (snapshot.hasData) {
              numberOfClips = snapshot.data.length;
              final bool largeList = numberOfClips > kNoSubClipLimit;
              final List<Widget> cards = largeList
                ? snapshot.data
                  .sublist(0, kNoSubClipLimit)
                  .map(cardMapper).toList()
                : snapshot.data
                  .map(cardMapper).toList();
              
              // View All
              cards.add(ViewAllCard(
                onTap: () {
                  Routes.router.navigateTo(
                    context,
                    'clip/all/${user.uid}/${user.displayName}/$me',
                  );
                },
              ));

              clipsContent = HorizontalCardList(cards: cards);
            } else {
              clipsContent = Container(
                height: 200.0,
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Center(
                    child: const Text(
                      kNoClipsCopy,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextHeader(
                  'Clips',
                  actions: me
                    ? <Widget>[
                      IconButton(
                        icon: Icon(MdiIcons.plusCircleOutline),
                        onPressed: () {
                          final DialogHelper helper = DialogHelper.instance();

                          if (subscriber) {
                            if (numberOfClips < kSubClipLimit) {
                              Routes.router.navigateTo(context, 'clip/create/${user.uid}');
                            } else {
                              helper.showErrorDialog(
                                context: context,
                                title: 'Can\'t Add More Clips',
                                message: kSubClipLimitMessage,
                              );
                            }
                          } else {
                            if (numberOfClips < kNoSubClipLimit) {
                              Routes.router.navigateTo(context, 'clip/create/${user.uid}');
                            } else {
                              helper.showSubscribeDialog(
                                context: context,
                                message: kNoSubClipLimitMessage,
                              );
                            }
                          }
                        },
                      )
                    ]
                  : <Widget>[],
                ),
                clipsContent,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PrivateBody extends StatelessWidget {
  const _PrivateBody({
    @required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Profile header
        _PrivateHeader(user: user),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  MdiIcons.lock,
                  size: 120.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'This profile is private',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
