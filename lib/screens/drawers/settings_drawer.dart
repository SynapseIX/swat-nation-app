import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/screens/auth/sign_in_screen.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/utils/url_launcher.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.instance();
    
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: _NoAuthHeader(),
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
        ],
      ),
    );
  }
}

class _NoAuthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
              fadeInDuration: Duration(milliseconds: 300),
              width: 60.0,
              height: 60.0,
            ),
          ),
        ),
        title: Text(
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
    );
  }
}
