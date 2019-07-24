import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

import 'base_bloc.dart';

/// BLoC that allows to change the application theme.
class ThemeBloc extends BaseBloc {
  factory ThemeBloc.instance() {
    return _bloc;
  }

  ThemeBloc._internal();

  static final ThemeBloc _bloc = ThemeBloc._internal();

  final BehaviorSubject<BaseTheme> _themeSubject = BehaviorSubject<BaseTheme>.seeded(LightTheme());

  Stream<BaseTheme> get stream => _themeSubject.stream;
  BaseTheme get currentTheme => _themeSubject.value;

  void Function(BaseTheme) get changeTheme => _themeSubject.sink.add;

  @override
  void dispose() {
    _themeSubject.close();
  }
}
