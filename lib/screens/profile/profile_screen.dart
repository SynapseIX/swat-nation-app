import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/art_card.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

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
  UserModel user;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc.instance();
    user = widget.model;
  }

  @override
  void dispose() {
    authBloc.dispose();
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
            backgroundColor: ThemeBloc.instance().currentTheme is DarkTheme
              ? const Color(0xFF333333)
              : Theme.of(context).primaryColor,
            title: me
              ? const Text('My Profile')
              : const Text('Member Profile'),
            actions: me
              ? <Widget>[
                IconButton(
                  icon: const Icon(MdiIcons.accountEdit),
                  onPressed: () => print('TODO: navigate to edit profile'),
                ),
              ]
              : <Widget>[],
          ),
          body: me || !user.private
            ? _PublicBody(user)
            : _PrivateBody(user),
        );
      },
    );
  }
}

class _PublicHeader extends StatelessWidget {
  const _PublicHeader(this.model);

  final UserModel model;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        image: DecorationImage(
          image: CachedNetworkImageProvider(model.headerUrl ?? kDefaultProfileHeader),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xC0000000),
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
                    imageUrl: model.photoUrl,
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
                        model.displayName,
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
                      if (model.verified)
                      Container(
                        margin: const EdgeInsets.only(left: 4.0),
                        child: const VerifiedBadge(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Joined ${humanizeTimestamp(model.createdAt, 'MMMM yyyy')}',
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

          if (model.bio != null)
          Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              model.bio,
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

          if (model.gamertag != null)
          GestureDetector(
            onTap: () => openUrl('$kGamertag${model.twitter}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      MdiIcons.xbox,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      model.gamertag,
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

          if (model.twitter != null)
          GestureDetector(
            onTap: () => openUrl('https://twitter.com/${model.twitter}'),
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
                      model.twitter,
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

          if (model.mixer != null)
          GestureDetector(
            onTap: () => openUrl('https://mixer.com/${model.mixer}'),
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
                      model.mixer,
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

          if (model.twitch != null)
          GestureDetector(
            onTap: () => openUrl('https://twitch.tv/${model.twitch}'),
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
                      model.twitch,
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
          if (model.gamertag != null)
          GestureDetector(
            onTap: () => print('TODO: implement'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Row(
                  children: const <Widget>[
                    Icon(
                      MdiIcons.chartLine,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'SWAT Stats',
                      style: TextStyle(
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
        ],
      ),
    );
  }
}

class _PrivateHeader extends StatelessWidget {
  const _PrivateHeader(this.model);

  final UserModel model;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        image: DecorationImage(
          image: CachedNetworkImageProvider(model.headerUrl ?? kDefaultProfileHeader),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xC0000000),
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
                imageUrl: model.photoUrl,
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
                model.displayName,
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
              if (model.verified)
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
  const _PublicBody(this.model);

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('profile_list_view'),
      children: <Widget>[
        // Header
        _PublicHeader(model),

        // Achievements
        CardSection(
          header: const TextHeader(
            'Achievements',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          ),
          cardList: HorizontalCardList(
            key: const PageStorageKey<String>('achievements_list'),
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
        ),

        // Clips
        const TextHeader(
          'Clips',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
            margin: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
        ),
        const ClipCard(
          src: 'https://picsum.photos/640/360?random=1',
          duration: '28s',
          author: 'Gameplay by\n@itsprof',
          padding: EdgeInsets.all(8.0),
        ),
      ],
    );
  }
}

class _PrivateBody extends StatelessWidget {
  const _PrivateBody(this.model);

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _PrivateHeader(model),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  MdiIcons.lock,
                  size: 60.0,
                ),
                SizedBox(height: 16.0),
                Text('This is a private profile'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
