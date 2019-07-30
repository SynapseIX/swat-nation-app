import 'package:flutter/material.dart';
import 'package:swat_nation/screens/main_screen.dart';
import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

import 'blocs/theme_bloc.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  // TODO(itsprof): persist selected theme
  ThemeBloc themeBloc;

  @override
  void initState() {
    super.initState();
    themeBloc = ThemeBloc.instance();
    themeBloc.retrieveSavedTheme();
  }

  @override
  void dispose() {
    themeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseTheme>(
      stream: themeBloc.stream,
      initialData: LightTheme(),
      builder: (BuildContext context, AsyncSnapshot<BaseTheme> snapshot) {
        final BaseTheme theme = snapshot.data is LightTheme
          ? LightTheme()
          : DarkTheme();

        return MaterialApp(
          title: 'SWAT Nation',
          theme: theme.getThemeData(),
          home: MainScreen(),
        );
      },
    );
  }
}
