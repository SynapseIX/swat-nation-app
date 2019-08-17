import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

import 'edit_profile_screen.dart';

/// Represents the user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    @required this.model,
  });
  
  final UserModel model;

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthBloc authBloc;
  ClipsBloc clipsBloc;
  UserModel user;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc.instance();
    clipsBloc = ClipsBloc();
    user = widget.model;
  }

  @override
  void dispose() {
    authBloc.dispose();
    clipsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: authBloc.currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        final bool me = snapshot.hasData && user.uid == snapshot.data.uid;

        return Scaffold(
          appBar: AppBar(
            title: me
              ? const Text('My Profile')
              : const Text('Member Profile'),
            actions: <Widget>[
              if (me)
              IconButton(
                icon: const Icon(MdiIcons.accountEdit),
                onPressed: () => _navigateToEdit(),
              ),
              if (!me)
              IconButton(
                icon: const Icon(MdiIcons.alert),
                // TODO(itsprof): implement report user
                onPressed: () {},
              ),
            ]
          ),
          body: me || !user.private
            ? _PublicBody(bloc: clipsBloc, user: user, me: me)
            : _PrivateBody(user: user),
        );
      },
    );
  }

  Future<void> _navigateToEdit() async {
    final UserModel updatedUser = await Navigator.of(context).push(
      MaterialPageRoute<UserModel>(
        builder: (BuildContext context) {
          return EditProfileScreen(model: user);
        },
      ),
    );

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
                  borderRadius: BorderRadius.circular(40.0),
                  child: CachedNetworkImage(
                    imageUrl: user.photoUrl,
                    width: 40.0,
                    height: 40.0,
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
                        user.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      if (user.verified)
                      Container(
                        margin: const EdgeInsets.only(left: 4.0),
                        child: const VerifiedBadge(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Joined ${humanizeTimestamp(user.createdAt, 'MMMM yyyy')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
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
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ),

          if (user.gamertag != null)
          GestureDetector(
            onTap: () => openUrl('$kGamertag${user.twitter}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      MdiIcons.xbox,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      user.gamertag,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (user.twitter != null)
          GestureDetector(
            onTap: () => openUrl('https://twitter.com/${user.twitter}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      MdiIcons.twitter,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      user.twitter,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (user.mixer != null)
          GestureDetector(
            onTap: () => openUrl('https://mixer.com/${user.mixer}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      MdiIcons.mixer,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      user.mixer,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (user.twitch != null)
          GestureDetector(
            onTap: () => openUrl('https://twitch.tv/${user.twitch}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      MdiIcons.twitch,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      user.twitch,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // TODO(itsprof): uncomment when functionality done
          // if (model.gamertag != null)
          // GestureDetector(
          //   onTap: () => print('TODO: implement'),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       const SizedBox(height: 8.0),
          //       Row(
          //         children: const <Widget>[
          //           Icon(
          //             MdiIcons.chartLine,
          //             color: Colors.white,
          //             size: 20.0,
          //           ),
          //           SizedBox(width: 8.0),
          //           Text(
          //             'SWAT Stats',
          //             style: TextStyle(
          //               color: Colors.white,
          //               shadows: <Shadow>[
          //                 Shadow(
          //                   offset: Offset(1.0, 1.0),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
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
                imageUrl: user.photoUrl,
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
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              if (user.verified)
              Container(
                margin: const EdgeInsets.only(left: 4.0),
                child: const VerifiedBadge(),
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
    @required this.bloc,
    @required this.user,
    this.me = false,
  });

  final ClipsBloc bloc;
  final UserModel user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('profile_list_view'),
      children: <Widget>[
        // Profile header
        _PublicHeader(user: user),

        // Clips
        StreamBuilder<List<ClipModel>>(
          stream: bloc.allClipsForUser(user.uid),
          builder: (BuildContext context, AsyncSnapshot<List<ClipModel>> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final List<ClipModel> data = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CardSection(
                  header: TextHeader(
                    'Clips',
                    actions: me
                      ? <Widget>[
                        IconButton(
                          icon: Icon(MdiIcons.plusCircleOutline),
                          // TODO(itsprof): implement
                          onPressed: () {},
                        )
                      ]
                      : <Widget>[],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                    margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
                  ),
                  cardList: HorizontalCardList(
                    cards: data
                      .map((ClipModel model) {
                        return ClipCard(
                          key: UniqueKey(),
                          model: model,
                        );
                      }).toList(),
                  ),
                ),
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
