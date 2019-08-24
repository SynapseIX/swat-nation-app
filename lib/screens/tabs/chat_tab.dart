import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/chat_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/models/chat_model.dart';
import 'package:swat_nation/models/user_model.dart';
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
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  ChatBloc bloc;
  UserBloc userBloc;
  bool proRoom;

  @override
  void initState() {
    bloc = ChatBloc();
    userBloc = UserBloc();

    proRoom = false;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    bloc.dispose();
    userBloc.dispose();
    
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
        // TODO(itsprof): make popup menu button
        title: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(proRoom ? 'PRO Chat' : 'General Chat'),
              const SizedBox(width: 4.0),
              const Icon(MdiIcons.menuDown),
            ],
          ),
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
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Column(
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
            FutureBuilder<FirebaseUser>(
              future: AuthBloc.instance().currentUser,
              builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: !snapshot.hasData
                    ? () {
                      // TODO(itsprof): implement
                      print('Sign in...');
                    }
                    : null,
                  child: IgnorePointer(
                    ignoring: !snapshot.hasData,
                    child: CommentInput(
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: (String value) async {
                        if (value.trim().isNotEmpty) {
                          final UserModel user = await userBloc
                            .userByUid(snapshot.data.uid);

                          final ChatModel message = ChatModel(
                            message: value,
                            createdAt: Timestamp.now(),
                            author: user.uid,
                            displayName: user.displayName,
                            photoUrl: user.photoUrl,
                            verified: user.verified,
                          );

                          bloc.sendMessageToGeneral(message);
                          controller.clear();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _dismissKeyboard() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }
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
