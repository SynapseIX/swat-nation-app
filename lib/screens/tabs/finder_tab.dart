import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';

/// Represents the team finder tab screen.
class FinderTab extends StatefulWidget implements BaseTab {
  const FinderTab({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FinderTabState();

  @override
  IconData get icon => MdiIcons.accountSearch;

  @override
  String get title => 'Finder';
}

class _FinderTabState extends State<FinderTab> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.lightGreen);
  }
}
