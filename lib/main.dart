import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App();
  
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
  
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAT Nation',
      home: Container(),
    );
  }
}
