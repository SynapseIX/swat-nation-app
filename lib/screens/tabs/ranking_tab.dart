import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';

/// Represents the ranking tab screen.
class RankingTab extends StatefulWidget implements BaseTab {
  const RankingTab({ Key key }) : super(key: key);

  @override
  State createState() => _RankingTabState();

  @override
  IconData get icon => MdiIcons.medal;

  @override
  String get title => 'Ranking';
}

class _RankingTabState extends State<RankingTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(color: Colors.purple);
  }

  @override
  bool get wantKeepAlive => true;
}
