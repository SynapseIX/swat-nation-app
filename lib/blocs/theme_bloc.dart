import 'package:rxdart/rxdart.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/themes.dart';

/// BLoC that allows to change the application theme.
class ThemeBloc extends BaseBloc {
  factory ThemeBloc.instance() {
    return _bloc;
  }

  ThemeBloc._internal();

  static final ThemeBloc _bloc = ThemeBloc._internal();

  final BehaviorSubject<AppTheme> _themeSubject = BehaviorSubject<AppTheme>.seeded(AppTheme.light);

  Stream<AppTheme> get stream => _themeSubject.stream;
  AppTheme get currentTheme => _themeSubject.value;

  void Function(AppTheme) get changeTheme => _themeSubject.sink.add;

  @override
  void dispose() {
    _themeSubject.close();
  }
}
