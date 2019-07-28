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
    final ThemeBloc bloc = ThemeBloc.instance();
    final BaseTheme currentTheme = bloc.currentTheme;
    
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: _NoAuthHeader(),
          ),
          
          // Social
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.web),
                SizedBox(width: 8.0),
                Text('Check out our Website'),
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
                Text('Follow us on Instagram'),
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
                const Text('Dark Theme'),
                Spacer(),
                Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: currentTheme is DarkTheme,
                  // TODO(itsprof): persist theme
                  onChanged: (bool value) => bloc.changeTheme(value ? DarkTheme() : LightTheme()),
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
    return ListTile(
      title: Row(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: 'https://static1.squarespace.com/static/5bfb2111372b964077959077/t/5bfcbd661ae6cf259c75a2ad/1563085290045/?format=500w',
              width: 40.0,
              height: 40.0,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            'Create Account / Sign In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: const Text(
          'SWAT Nation is better enjoyed if you create an account. If you already have an account, please sign in.',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
