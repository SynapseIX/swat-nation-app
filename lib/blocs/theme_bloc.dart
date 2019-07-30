import 'package:shared_preferences/shared_preferences.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/themes/base_theme.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

/// BLoC that allows to change the application theme.
class ThemeBloc extends BaseBloc {
  factory ThemeBloc.instance() {
    return _bloc;
  }

  ThemeBloc._internal();
  static final ThemeBloc _bloc = ThemeBloc._internal();
  
  final String _prefKey = 'theme';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final BehaviorSubject<BaseTheme> _themeSubject = BehaviorSubject<BaseTheme>();

  Stream<BaseTheme> get stream => _themeSubject.stream;

  BaseTheme get currentTheme => _themeSubject.value;

  Future<void> retrieveSavedTheme() async {
    final SharedPreferences prefs = await _prefs;
    final String savedValue = prefs.get(_prefKey) ?? LightTheme.name;

    final BaseTheme savedTheme = savedValue == LightTheme.name ? LightTheme() : DarkTheme();
    _themeSubject.sink.add(savedTheme);
  }

  void changeTheme(BaseTheme theme) {
    _themeSubject.sink.add(theme);
    _persistTheme(theme is LightTheme ? LightTheme.name : DarkTheme.name);
  }
  
  Future<bool> _persistTheme(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_prefKey, name);
  }

  @override
  void dispose() {
    _themeSubject.close();
  }
}
