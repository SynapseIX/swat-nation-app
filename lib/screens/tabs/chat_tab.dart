import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/base/base_theme.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/chat_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/chat_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/common/comment_input.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';
import 'package:swat_nation/widgets/tiles/chat_list_tile.dart';

/// Represents the chat tab screen.
class ChatTab extends StatefulWidget implements BaseTab {
  const ChatTab({ Key key }) : super(key: key);

  @override
  State createState() => _ChatTabState();

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
        title: PopupMenuButton<ChatRooms>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ChatRooms>>[
            const PopupMenuItem<ChatRooms>(
              value: ChatRooms.general,
              child: Text('General Chat'),
            ),
            const PopupMenuItem<ChatRooms>(
              value: ChatRooms.pro,
              child: Text('PRO Chat'),
            ),
          ],
          onSelected: (ChatRooms room) {
            // TODO(itsprof): validate if subscriber
            controller.clear();
            setState(() {
              proRoom = room == ChatRooms.pro;
            });
          },
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
                stream: proRoom 
                  ? bloc.proRoomStream
                  : bloc.generalRoomStream,
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
                        onTap: (ChatModel model) async {
                          _dismissKeyboard();

                          Future<void>.delayed(
                            kKeyboardAnimationDuration,
                            () async {
                              final FirebaseUser currentUser = await AuthBloc
                                .instance()
                                .currentUser;
                              if (currentUser == null) {
                                return DialogHelper
                                  .instance()
                                  .showSignInDIalog(context: context);
                              }

                              if (model.author != currentUser.uid) {
                                _showMessageOptions(context, model);
                              }
                            }
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            StreamBuilder<FirebaseUser>(
              stream: AuthBloc.instance().onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: !userSnapshot.hasData
                    ? () => DialogHelper.instance().showSignInDIalog(context: context)
                    : null,
                  child: IgnorePointer(
                    ignoring: !userSnapshot.hasData,
                    child: StreamBuilder<BaseTheme>(
                      stream: ThemeBloc.instance().stream,
                      builder: (BuildContext context, AsyncSnapshot<BaseTheme> themeSnapshot) {
                        final BaseTheme theme = themeSnapshot.data;

                        return CommentInput(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardAppearance: theme is DarkTheme
                            ? Brightness.dark
                            : Brightness.light,
                          fillColor: theme is DarkTheme
                            ? const Color(0xFF111111)
                            : Colors.white,
                          onSubmitted: (String value) async {
                            if (value.trim().isNotEmpty) {
                              final UserModel user = await userBloc
                                .userByUid(userSnapshot.data.uid);

                              final ChatModel message = ChatModel(
                                message: value,
                                createdAt: Timestamp.now(),
                                author: user.uid,
                                displayName: user.displayName,
                                photoUrl: user.photoUrl,
                                verified: user.verified,
                              );

                              if (proRoom) {
                                bloc.sendMessageToPro(message);
                              } else {
                                bloc.sendMessageToGeneral(message);
                              }

                              controller.clear();
                            }
                          },
                        );
                      }
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

  Future<void> _showMessageOptions(BuildContext context, ChatModel model) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3.0,
                      color: Colors.white,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: CachedNetworkImage(
                      imageUrl: model.photoUrl ?? kDefaultAvi,
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      model.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    if (model.verified)
                    const VerifiedBadge(
                      margin: EdgeInsets.only(left: 4.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(model.message),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    child: const Text('View Profile'),
                    onPressed: () async {
                      Navigator.pop(context);
                      final FirebaseUser user = await AuthBloc.instance().currentUser;
                      Routes.router.navigateTo(context, '/profile/${user.uid}/${model.author}');
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.red,
                    child: const Text(
                      'Report',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // TODO(itsprof): implement
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

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
          ),
        ],
      ),
    );
  }
}
