import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    Key key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.instance();
    
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('SWAT Nation'),
          actions: const <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            StreamBuilder<FirebaseUser>(
              stream: AuthBloc.instance().onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                return snapshot.hasData
                  ? _AuthHeader(snapshot.data)
                  : _NoAuthHeader();
              },
            ),

            const SizedBox(height: 8.0),

            // About Us
            ListTile(
              leading: const Icon(MdiIcons.information),
              title: const Text('About SWAT Nation'),
              trailing: const Icon(MdiIcons.chevronRight),
              onTap: () => Routes.router.navigateTo(context, Routes.aboutUs),
            ),

            // Store
            ListTile(
              leading: const Icon(MdiIcons.cart),
              title: const Text('Visit the Store'),
              trailing: const Icon(MdiIcons.chevronRight),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(),
            
            // Social
            ListTile(
              leading: const Icon(MdiIcons.web),
              title: const Text('Browse our Website'),
              onTap: () {
                openUrl(kWebsite);
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.facebookBox),
              title: const Text('Join the Community'),
              onTap: () {
                openUrl(kFacebookGroup);
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.twitter),
              title: const Text('Follow us on Twitter'),
              onTap: () {
                openUrl(kTwitter);
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.instagram),
              title: const Text('Check our Instagram'),
              onTap: () {
                openUrl(kInstagram);
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.xbox),
              title: const Text('Join the Xbox Club'),
              onTap: () {
                openUrl(kXboxClub);
              },
            ),

            const Divider(),

            // Change theme
            ListTile(
              leading: const Icon(MdiIcons.weatherNight),
              title: const Text('Dark Mode'),
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: themeBloc.currentTheme is DarkTheme,
                onChanged: (bool value) => themeBloc.changeTheme(value ? DarkTheme() : LightTheme()),
              ),
            ),

            // Sign out
            StreamBuilder<FirebaseUser>(
              stream: AuthBloc.instance().onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: const Icon(MdiIcons.logout),
                    title: const Text('Sign Out...'),
                    onTap: () {
                      showDialog<Dialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              margin: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF333333),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: kLogo,
                                      fadeInDuration: const Duration(milliseconds: 300),
                                      width: 100.0,
                                      height: 100.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text('Are you sure you want to sign out?'),
                                  const SizedBox(height: 32.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await AuthBloc.instance().signOut();
                                        Navigator.pop(context);
                                        TabBarBloc.instance().controller.jumpToPage(0);
                                      },
                                      child: const Text('Yes, sign me out'),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('No, take me back'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      )
    );
  }
}

class _NoAuthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Center(
        child: ListTile(
          leading: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              imageUrl: kLogo,
              fadeInDuration: const Duration(milliseconds: 300),
              width: 60.0,
              height: 60.0,
            ),
          ),
          title: const Text(
            'Create Account / Sign In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: const Text(
              'You\'re signed out of SWAT Nation. Sign in to register for tourneys, chat, and subscribe.',
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          onTap: () async {
            Routes.router.navigateTo(context, Routes.signIn);
          },
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader(this.user);
  
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserBloc();

    return FutureBuilder<UserModel>(
      future: userBloc.userByUid(user.uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          final UserModel model = snapshot.data;

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  model.headerUrl ?? kDefaultProfileHeader,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              accountName: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(user.displayName),
                  if (model.verified)
                  const VerifiedBadge(
                    margin: EdgeInsets.only(left: 4.0),
                  ),
                ],
              ),
              accountEmail: Text(user.email),
              currentAccountPicture: Container(
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
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              onDetailsPressed: () {
                Navigator.pop(context);
                Routes.router.navigateTo(context, '/profile/${model.uid}');
              },
            ),
          );
        }
        
        return DrawerHeader(
          margin: EdgeInsets.zero,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}
