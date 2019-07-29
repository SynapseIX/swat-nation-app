import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

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
            title: Row(
              children: <Widget>[
                Icon(MdiIcons.information),
                const SizedBox(width: 8.0),
                const Text('About Us'),
                const Spacer(),
                Icon(
                  MdiIcons.chevronRight,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),

          // Store
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(MdiIcons.cart),
                const SizedBox(width: 8.0),
                const Text('Visit the Store'),
                const Spacer(),
                Icon(
                  MdiIcons.chevronRight,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),
          
          // Social
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.web),
                SizedBox(width: 8.0),
                Text('Visit our Website'),
              ],
            ),
            onTap: () {
              openURL(kWebsite);
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.facebook),
                SizedBox(width: 8.0),
                Text('Join the Community'),
              ],
            ),
            onTap: () {
              openURL(kFacebookGroup);
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.twitter),
                SizedBox(width: 8.0),
                Text('Follow us on Twitter'),
              ],
            ),
            onTap: () {
              openURL(kTwitter);
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.instagram),
                SizedBox(width: 8.0),
                Text('Check our Instagram'),
              ],
            ),
            onTap: () {
              openURL(kInstagram);
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.xbox),
                SizedBox(width: 8.0),
                Text('Join the Xbox Club'),
              ],
            ),
            onTap: () {
              openURL(kXboxClub);
              Navigator.of(context).pop();
            },
          ),
          const Divider(indent: 16.0),

          // Change theme
          ListTile(
            title: Row(
              children: <Widget>[
                const Icon(MdiIcons.weatherNight),
                const SizedBox(width: 8.0),
                const Text('Dark Mode'),
                const Spacer(),
                FutureBuilder<BaseTheme>(
                  future: themeBloc.currentTheme,
                  builder: (BuildContext context, AsyncSnapshot<BaseTheme> snapshot) {
                    return Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: snapshot.data is DarkTheme,
                      onChanged: (bool value) => themeBloc.changeTheme(value ? DarkTheme() : LightTheme()),
                    );
                  },
                ),
              ],
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
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: 'https://static1.squarespace.com/static/5bfb2111372b964077959077/t/5bfcbd661ae6cf259c75a2ad/1563085290045/?format=500w',
            width: 60.0,
            height: 60.0,
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
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
