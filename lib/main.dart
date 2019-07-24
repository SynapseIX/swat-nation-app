import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'blocs/tab_bar_bloc.dart';
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
  TabBarBloc tabBarBloc;

  List<Widget> tabs;

  @override
  void initState() {
    themeBloc = ThemeBloc.instance();
    tabBarBloc = TabBarBloc.instance();

    tabs = _kDummyScreens;

    super.initState();
  }

  @override
  void dispose() {
    themeBloc.dispose();
    tabBarBloc.dispose();
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
          home: StreamBuilder<int>(
            initialData: 0,
            stream: tabBarBloc.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Scaffold(
                body: SafeArea(
                  child: tabs[snapshot.data],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: snapshot.data,
                  type: BottomNavigationBarType.fixed,
                  onTap: (int index) {
                    tabBarBloc.setCurrentIndex(index);
                  },
                  selectedItemColor: theme.primaryColor,
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
                      icon: Icon(MdiIcons.information),
                      title: const Text('About'),
                    ),
                  ],
                ),
              );
            }
          ),
        );
      },
    );
  }
}

// TODO(itsprof): remove everything below this comment

class _DummyScreen extends StatelessWidget {
  const _DummyScreen({
    @required this.title,
    this.onPressed,
  });
  
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}

final List<Widget> _kDummyScreens = List<Widget>.generate(5, (int i) {
  return _DummyScreen(
    title: 'Tab $i',
    onPressed: () {
      final ThemeBloc themeBloc = ThemeBloc.instance();
      final AppTheme currentTheme = themeBloc.currentTheme;

      themeBloc.changeTheme(currentTheme == AppTheme.light 
        ? AppTheme.dark
        : AppTheme.light);
    },
  );
});
