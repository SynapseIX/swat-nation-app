import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/chat_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/models/chat_model.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/widgets/common/comment_input.dart';
import 'package:swat_nation/widgets/tiles/chat_list_tile.dart';

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
  ChatBloc bloc;

  @override
  void initState() {
    bloc = ChatBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: bloc.generalRoomStream,
              builder: (BuildContext context, AsyncSnapshot<List<ChatModel>> snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return _EmptyState();
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ChatModel model = snapshot.data[index];
                    return ChatListTile(
                      key: UniqueKey(),
                      model: model,
                      onTap: (ChatModel model) {
                        print('Tapped ${model.message}');
                      },
                    );
                  },
                );
              },
            ),
          ),
          CommentInput(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Icon(
            MdiIcons.chatProcessing,
            size: 80.0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Chat messages appear here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          )
        ],
      ),
    );
  }
}
