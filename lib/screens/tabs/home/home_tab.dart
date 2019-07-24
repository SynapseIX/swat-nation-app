import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: const Text('Welcome to SWAT Nation'),
        ),
      ],
    );
  }
}
