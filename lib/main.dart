import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'blocs/theme_bloc.dart';
import 'themes.dart';

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

  int selectedTabIndex;
  List<Widget> tabs;

  @override
  void initState() {
    themeBloc = ThemeBloc.instance();

    selectedTabIndex = 0;
    tabs = <Widget>[
      _DummyScreen(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          final AppTheme currentTheme = themeBloc.currentTheme;
          themeBloc.changeTheme(currentTheme == AppTheme.light 
            ? AppTheme.dark
            : AppTheme.light);
        },
      ),
      _DummyScreen(
        backgroundColor: Colors.lime,
        onPressed: () {
          final AppTheme currentTheme = themeBloc.currentTheme;
          themeBloc.changeTheme(currentTheme == AppTheme.light 
            ? AppTheme.dark
            : AppTheme.light);
        },
      ),
      _DummyScreen(
        backgroundColor: Colors.purple,
        onPressed: () {
          final AppTheme currentTheme = themeBloc.currentTheme;
          themeBloc.changeTheme(currentTheme == AppTheme.light 
            ? AppTheme.dark
            : AppTheme.light);
        },
      ),
      _DummyScreen(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          final AppTheme currentTheme = themeBloc.currentTheme;
          themeBloc.changeTheme(currentTheme == AppTheme.light 
            ? AppTheme.dark
            : AppTheme.light);
        },
      ),
      _DummyScreen(
        backgroundColor: Colors.grey,
        onPressed: () {
          final AppTheme currentTheme = themeBloc.currentTheme;
          themeBloc.changeTheme(currentTheme == AppTheme.light 
            ? AppTheme.dark
            : AppTheme.light);
        },
      ),
    ];

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
        final ThemeData theme = snapshot.data == AppTheme.light
          ? lightTheme
          : darkTheme;

        return MaterialApp(
          title: 'SWAT Nation',
          theme: theme,
          home: Scaffold(
            body: tabs[selectedTabIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedTabIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.home),
                  title: const Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.trophy),
                  title: const Text('Tourneys'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.accountSearch),
                  title: const Text('Team Finder'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.chat),
                  title: const Text('Chat'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.store),
                  title: const Text('Store'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DummyScreen extends StatelessWidget {
  const _DummyScreen({
    this.backgroundColor,
    this.onPressed,
  });
  
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: RaisedButton(
          onPressed: onPressed,
          child: const Text('Change Theme'),
        ),
      ),
    );
  }
}
