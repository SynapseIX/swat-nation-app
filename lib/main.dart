import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/screens/tabs/home/home_tab.dart';
import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

import 'blocs/tab_bar_bloc.dart';
import 'blocs/theme_bloc.dart';

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

    tabs = <Widget>[
      HomeTab(),
      Container(color: Colors.lightBlue),
      Container(color: Colors.lightGreen),
      Container(color: Colors.pink),
      Container(color: Colors.purple),
    ];

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
          home: StreamBuilder<int>(
            initialData: 0,
            stream: tabBarBloc.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Scaffold(
                body: tabs[snapshot.data],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: snapshot.data,
                  type: BottomNavigationBarType.fixed,
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
                  onTap: (int index) {
                    tabBarBloc.setCurrentIndex(index);
                  },
                ),
              );
            }
          ),
        );
      },
    );
  }
}
