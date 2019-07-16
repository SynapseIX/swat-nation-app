import 'package:rxdart/rxdart.dart';
import 'package:swat_nation/themes/app_theme.dart';

/// BLoC that allows to change the application theme.
class ThemeBloc {
  final BehaviorSubject<AppTheme> _themeSubject = BehaviorSubject<AppTheme>();

  Stream<AppTheme> get stream => _themeSubject.stream;
  AppTheme get currentTheme => _themeSubject.value;

  void Function(AppTheme) get changeTheme => _themeSubject.sink.add;

  void dispose() {
    _themeSubject.close();
  }
}
