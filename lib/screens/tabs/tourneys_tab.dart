import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';

/// Represents the tourneys tab screen.
class TourneysTab extends StatefulWidget implements BaseTab {
  const TourneysTab({ Key key }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _TourneysTabState();

  @override
  IconData get icon => MdiIcons.trophy;

  @override
  String get title => 'Tourneys';
}

class _TourneysTabState extends State<TourneysTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(color: Colors.lightBlue);
  }

  @override
  bool get wantKeepAlive => true;
}
