import 'package:flutter/material.dart';
import 'package:swat_nation/themes/app_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

// TODO(itsprof): provide BLoC to change the theme
void main() => runApp(const App());

class App extends StatefulWidget {
  const App();

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
  
}

class AppState extends State<App> {
  // TODO(itsprof): persist selected theme
  AppTheme selectedTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAT Nation',
      theme: lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SWAT Nation'),
        ),
      ),
    );
  }
}
