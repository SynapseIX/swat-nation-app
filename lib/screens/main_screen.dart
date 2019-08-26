import 'package:flutter/material.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/screens/drawers/settings_drawer.dart';
import 'package:swat_nation/screens/tabs/chat_tab.dart';
import 'package:swat_nation/screens/tabs/finder_tab.dart';
import 'package:swat_nation/screens/tabs/home_tab.dart';
import 'package:swat_nation/screens/tabs/ranking_tab.dart';
import 'package:swat_nation/screens/tabs/tourneys_tab.dart';
import 'package:swat_nation/themes/dark_theme.dart';

/// Main screen that holds the bottom navigation bar.
class MainScreen extends StatefulWidget {
  const MainScreen({ Key key }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BaseTab> tabs;

  @override
  void initState() {
    tabs = <BaseTab>[
      const HomeTab(),
      const TourneysTab(),
      const FinderTab(),
      const ChatTab(),
      const RankingTab(),
    ];

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingsDrawer(),
      body: PageView(
        controller: TabBarBloc.instance().controller,
        physics: const NeverScrollableScrollPhysics(),
        children: tabs,
        onPageChanged: (int page) => TabBarBloc.instance().setCurrentIndex(page),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: TabBarBloc.instance().stream,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return BottomNavigationBar(
            backgroundColor: ThemeBloc.instance().currentTheme is DarkTheme
              ? const Color(0xFF111111)
              : Colors.white,
            currentIndex: snapshot.data,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            items: tabs.map((BaseTab tab) {
              return BottomNavigationBarItem(
                icon: Icon(tab.icon),
                title: Text(tab.title),
              );
            }).toList(),
            onTap: (int index) => TabBarBloc.instance().controller.jumpToPage(index),
          );
        }
      ),
    );
  }
}
