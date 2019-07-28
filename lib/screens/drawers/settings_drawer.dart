import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

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
            onTap: () => Navigator.of(context).pop(),
          ),
          Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.facebook),
                SizedBox(width: 8.0),
                Text('Join the Community'),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.twitter),
                SizedBox(width: 8.0),
                Text('Follow us on Twitter'),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.instagram),
                SizedBox(width: 8.0),
                Text('Follow us on Instagram'),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Divider(indent: 16.0),
          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(MdiIcons.xbox),
                SizedBox(width: 8.0),
                Text('Join the Xbox Club'),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Divider(indent: 16.0),

          // Change theme
          ListTile(
            title: Row(
              children: <Widget>[
                const Text('Dark Theme'),
                Spacer(),
                Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: currentTheme is DarkTheme,
                  onChanged: (bool value) {
                    // TODO(itsprof): persist theme
                    final BaseTheme newTheme = currentTheme is LightTheme ? DarkTheme() : LightTheme();
                    bloc.changeTheme(newTheme);
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
    return ListTile(
      title: Row(
        children: const <Widget>[
          Icon(
            MdiIcons.login,
            size: 30.0,
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
