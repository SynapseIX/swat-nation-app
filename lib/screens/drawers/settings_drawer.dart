import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/screens/auth/sign_in_screen.dart';
import 'package:swat_nation/screens/profile/profile_screen.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/utils/url_launcher.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.instance();
    final Color scaffoldBackgroundColor = themeBloc.currentTheme is LightTheme
      ? Colors.white
      : const Color(0xFF333333);
    
    return Drawer(
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
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

            // About Us
            ListTile(
              leading: const Icon(MdiIcons.information),
              title: const Text('About SWAT Nation'),
              trailing: const Icon(MdiIcons.chevronRight),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),

            // Store
            ListTile(
              leading: const Icon(MdiIcons.cart),
              title: const Text('Visit the Store'),
              trailing: const Icon(MdiIcons.chevronRight),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),

            const Divider(),
            
            // Social
            ListTile(
              leading: const Icon(MdiIcons.web),
              title: const Text('Browse our Website'),
              onTap: () {
                openURL(kWebsite);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.facebookBox),
              title: const Text('Join the Community'),
              onTap: () {
                openURL(kFacebookGroup);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.twitter),
              title: const Text('Follow us on Twitter'),
              onTap: () {
                openURL(kTwitter);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.instagram),
              title: const Text('Check our Instagram'),
              onTap: () {
                openURL(kInstagram);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(MdiIcons.xbox),
              title: const Text('Join the Xbox Club'),
              onTap: () {
                openURL(kXboxClub);
                Navigator.of(context).pop();
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
                      Navigator.of(context).pop();
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
                                    child: Hero(
                                      tag: 'swat_nation_logo',
                                      child: CachedNetworkImage(
                                        imageUrl: kLogo,
                                        fadeInDuration: const Duration(milliseconds: 300),
                                        width: 120.0,
                                        height: 120.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32.0),
                                  const Text('Are you sure you want to sign out?'),
                                  const SizedBox(height: 32.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        AuthBloc.instance().signOut();
                                      },
                                      child: const Text('Yes, sign me out'),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      onPressed: () => Navigator.of(context).pop(),
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
            child: Hero(
              tag: 'swat_nation_logo',
              child: CachedNetworkImage(
                imageUrl: kLogo,
                fadeInDuration: const Duration(milliseconds: 300),
                width: 60.0,
                height: 60.0,
              ),
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
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<SignInScreen>(
                fullscreenDialog: true,
                builder: (BuildContext context) => SignInScreen(),
              ),
            );
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

    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () async {
          final DocumentSnapshot doc =  await userBloc.userByUid(user.uid);
          final UserModel model = UserModel.documentSnapshot(doc);

          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute<ProfileScreen>(
              builder: (BuildContext context) => ProfileScreen(model: model),
              fullscreenDialog: true,
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            // Header Image
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

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Profile picture
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
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  // Display name
                  Text(
                    user.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Email
                  Text(
                    user.email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
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
