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

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc.instance();
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
        final bool me = snapshot.hasData && widget.model.uid == snapshot.data.uid;

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
          body: widget.model.private
            ? const SizedBox()
            : ListView(
              children: <Widget>[
                SizedBox(
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
                                imageUrl: widget.model.photoUrl,
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(milliseconds: 300),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.model.displayName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Member since\n${humanizeTimestamp(widget.model.createdAt)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              if (widget.model.gamertag != null)
                              GestureDetector(
                                onTap: () => openURL('$kGamertag${widget.model.gamertag}'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(MdiIcons.xbox),
                                    const SizedBox(width: 8.0),
                                    Text(widget.model.gamertag),
                                  ],
                                ),
                              ),
                              if (widget.model.twitter != null)
                              GestureDetector(
                                onTap: () => openURL('http://twitter.com/${widget.model.twitter}'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(MdiIcons.twitter),
                                    const SizedBox(width: 8.0),
                                    Text(widget.model.twitter),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        );
      },
    );
  }
}
