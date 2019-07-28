import 'package:flutter/material.dart';
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
            child: SizedBox.expand(),
          ),
          ListTile(
            title: const Text('Create Account / Sign In'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                const Text('Dark Theme'),
                Spacer(),
                Switch(
                  value: currentTheme is DarkTheme,
                  onChanged: (bool value) {
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
