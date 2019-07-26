import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';

/// Represents the chat tab screen.
class ChatTab extends StatefulWidget implements BaseTab {
  const ChatTab({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatTabState();

  @override
  IconData get icon => MdiIcons.chat;

  @override
  String get title => 'Chat';
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.orange);
  }
}
