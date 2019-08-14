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
            actions: <Widget>[
              if (me)
              IconButton(
                icon: Icon(MdiIcons.accountEdit),
                onPressed: () {
                  print('TODO: navigate to edit profile screen');
                },
              ),
            ],
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
    return SizedBox(
      width: double.infinity,
      height: model.bio != null ? 270.0 : 210.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: kDefaultProfileHeader,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: (BuildContext context, String url) {
              return Center(child: const CircularProgressIndicator());
            },
          ),

          // Overlay
          Container(
            color: Colors.black45,
            width: double.infinity,
            height: double.infinity,
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
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
                  borderRadius: BorderRadius.circular(60.0),
                  child: CachedNetworkImage(
                    imageUrl: model.photoUrl,
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              
              const SizedBox(height: 8.0),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    model.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (model.verified)
                  Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      MdiIcons.checkDecagram,
                      color: Colors.lightBlue,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8.0),
              
              Text(
                'Member since\n${humanizeTimestamp(model.createdAt)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              if (model.bio != null)
              const SizedBox(height: 8.0),
              if (model.bio != null)
              Container(
                margin: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Text(
                  model.bio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (model.gamertag != null)
                  GestureDetector(
                    onTap: () => openUrl('$kGamertag${model.gamertag}'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          MdiIcons.xbox,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          model.gamertag,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.twitter != null)
                  GestureDetector(
                    onTap: () => openUrl('https://twitter.com/${model.twitter}'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          MdiIcons.twitter,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          model.twitter,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.gamertag != null)
                  GestureDetector(
                    onTap: () {
                      print('TODO: navigate to stats screen');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          MdiIcons.chartLine,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'SWAT Stats',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: kDefaultProfileHeader,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: (BuildContext context, String url) {
              return Center(child: const CircularProgressIndicator());
            },
          ),

          // Overlay
          Container(
            color: Colors.black45,
            width: double.infinity,
            height: double.infinity,
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
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
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    model.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (model.verified)
                  Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      MdiIcons.checkDecagram,
                      color: Colors.lightBlue,
                      size: 20.0,
                    ),
                  ),
                ],
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
