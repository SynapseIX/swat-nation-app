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

  final BehaviorSubject<BaseTheme> _themeSubject = BehaviorSubject<BaseTheme>.seeded(LightTheme());

  Stream<BaseTheme> get stream => _themeSubject.stream;

  Future<BaseTheme> get currentTheme async {
    final String savedKey = await _persistedTheme;

    if (savedKey == null) {
      return _themeSubject.value;
    }

    return savedKey == LightTheme.name ? LightTheme() : DarkTheme();
  }

  void changeTheme(BaseTheme theme) {
    _themeSubject.sink.add(theme);
    _persistTheme(theme is LightTheme ? LightTheme.name : DarkTheme.name);
  }
  
  Future<bool> _persistTheme(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_prefKey, name);
  }
  
  Future<String> get _persistedTheme async {
    final SharedPreferences prefs = await _prefs;
    return prefs.get(_prefKey);
  }

  @override
  void dispose() {
    _themeSubject.close();
  }
}
