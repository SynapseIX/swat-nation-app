import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';

/// Represents the about us tab screen.
class AboutTab extends StatefulWidget implements BaseTab {
  const AboutTab({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutTabState();

  @override
  IconData get icon => MdiIcons.information;

  @override
  String get title => 'About';
}

class _AboutTabState extends State<AboutTab> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.purple);
  }
}
