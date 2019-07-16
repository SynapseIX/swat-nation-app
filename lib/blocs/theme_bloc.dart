import 'package:rxdart/rxdart.dart';
import 'package:swat_nation/themes.dart';

/// BLoC that allows to change the application theme.
class ThemeBloc {
  factory ThemeBloc.instance() {
    return _bloc;
  }

  ThemeBloc._internal();

  static final ThemeBloc _bloc = ThemeBloc._internal();

  final BehaviorSubject<AppTheme> _themeSubject = BehaviorSubject<AppTheme>.seeded(AppTheme.light);

  Stream<AppTheme> get stream => _themeSubject.stream;
  AppTheme get currentTheme => _themeSubject.value;

  void Function(AppTheme) get changeTheme => _themeSubject.sink.add;

  void dispose() {
    _themeSubject.close();
  }
}
