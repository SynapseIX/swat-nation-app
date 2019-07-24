import 'package:swat_nation/base/base_bloc.dart';

class TabBarBloc extends BaseBloc {
  factory TabBarBloc.instance() {
    return _bloc;
  }

  TabBarBloc._internal();

  static final TabBarBloc _bloc = TabBarBloc._internal();

  final BehaviorSubject<int> _tabBarSubject = BehaviorSubject<int>();

  Stream<int> get stream => _tabBarSubject.stream;
  int get currentIndex => _tabBarSubject.value;

  void Function(int) get setCurrentIndex => _tabBarSubject.sink.add;

  @override
  void dispose() {
    _tabBarSubject.close();
  }
}
