import 'package:flutter/widgets.dart';
import 'package:swat_nation/base/base_bloc.dart';

/// BLoC that allows managing tab switching.
class TabBarBloc extends BaseBloc {
  factory TabBarBloc.instance() => _bloc;

  TabBarBloc._internal();

  static final TabBarBloc _bloc = TabBarBloc._internal();

  final PageController _controller = PageController();
  final BehaviorSubject<int> _tabBarSubject = BehaviorSubject<int>.seeded(0);

  Stream<int> get indexStream => _tabBarSubject.stream;
  int get currentIndex => _tabBarSubject.value;

  PageController get controller => _controller;
  void Function(int) get setCurrentIndex => _tabBarSubject.sink.add;

  @override
  void dispose() {
    print('TabBarBloc disposed');
    _tabBarSubject.close();
  }
}
