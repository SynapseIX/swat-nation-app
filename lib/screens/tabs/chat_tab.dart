import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/themes/light_theme.dart';

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

class _ChatTabState extends State<ChatTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeBloc.instance().currentTheme is LightTheme
          ? Colors.orange
          : Theme.of(context).appBarTheme.color,
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(
            MdiIcons.dotsVertical,
            color: Colors.white,
          ),
          // TODO(itsprof): navigate to PRO room
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              MdiIcons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          reverse: true,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return Text('$index');
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
