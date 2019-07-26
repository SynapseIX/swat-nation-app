import 'package:flutter/material.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/screens/tabs/about_tab.dart';
import 'package:swat_nation/screens/tabs/chat_tab.dart';
import 'package:swat_nation/screens/tabs/finder_tab.dart';
import 'package:swat_nation/screens/tabs/home_tab.dart';
import 'package:swat_nation/screens/tabs/tourneys_tab.dart';

/// Main screen that holds the bottom navigation bar.
class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  TabBarBloc bloc;

  HomeTab homeTab;
  TourneysTab tourneysTab;
  FinderTab finderTab;
  ChatTab chatTab;
  AboutTab aboutTab;

  List<BaseTab> tabs;

  @override
  void initState() {
    bloc = TabBarBloc.instance();

    homeTab = const HomeTab(key: PageStorageKey<String>('home'));
    tourneysTab = const TourneysTab(key: PageStorageKey<String>('tourneys'));
    finderTab = const FinderTab(key: PageStorageKey<String>('finder'));
    chatTab = const ChatTab(key: PageStorageKey<String>('chat'));
    aboutTab = const AboutTab(key: PageStorageKey<String>('about'));

    tabs = <BaseTab>[
      homeTab,
      tourneysTab,
      finderTab,
      chatTab,
      aboutTab,
    ];

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: bloc.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Scaffold(
          body: PageStorage(
            bucket: bucket,
            child: tabs[snapshot.data],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            items: tabs.map((BaseTab tab) {
              return BottomNavigationBarItem(
                icon: Icon(tab.icon),
                title: Text(tab.title),
              );
            }).toList(),
            onTap: (int index) => bloc.setCurrentIndex(index),
          ),
        );
      },
    );
  }
}
