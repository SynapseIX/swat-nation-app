import 'package:flutter/material.dart';

import 'blocs/theme_bloc.dart';
import 'themes.dart';

// TODO(itsprof): provide BLoC to change the theme
void main() => runApp(const App());

class App extends StatefulWidget {
  const App();

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
    themeBloc = ThemeBloc.instance();
    super.initState();
  }

  @override
  void dispose() {
    themeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppTheme>(
      stream: themeBloc.stream,
      builder: (BuildContext context, AsyncSnapshot<AppTheme> snapshot) {
        return MaterialApp(
          title: 'SWAT Nation',
          theme: snapshot.data == AppTheme.light ? lightTheme : darkTheme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('SWAT Nation'),
            ),
          ),
        );
      },
    );
  }
}
