import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_theme.dart';
import 'package:swat_nation/blocs/messaging_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/private_message_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/common/comment_input.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represents the private messaging screen between the user and another user.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    Key key,
    @required this.uid,
    @required this.recipientUid,
  }) : super(key: key);

  final String uid;
  final String recipientUid;
  
  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        final String recipientUid = parameters['recipientUid'].first;
        return ConversationScreen(
          uid: uid,
          recipientUid: recipientUid,
        );
      }
    );
  }

  @override
  State createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  MessagingBloc messagingBloc;
  UserBloc userBloc;

  @override
  void initState() {
    messagingBloc = MessagingBloc(uid: widget.uid);
    userBloc = UserBloc();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    messagingBloc.dispose();
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<PrivateMessageModel>>(
                  stream: messagingBloc.messages(widget.recipientUid),
                  builder:
                    (BuildContext context, AsyncSnapshot<List<PrivateMessageModel>> snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return _EmptyState();
                      }

                      final List<PrivateMessageModel> data = snapshot.data;
                      
                      return ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PrivateMessageModel message = data[index];
                          final bool me = message.uid == widget.uid;
                          
                          final bool needsNip = index == 0
                            || message.uid != data[index - 1].uid;
                          
                          final BubbleEdges margin = needsNip
                            ? const BubbleEdges.only(left: 16.0, right: 16.0, bottom: 16.0)
                            : const BubbleEdges.only(left: 16.0, right: 16.0, bottom: 4.0);
                          
                          BubbleNip nip;
                          if (needsNip) {
                            nip = me ? BubbleNip.rightBottom : BubbleNip.leftTop;
                          }

                          return Bubble(
                            nip: nip,
                            margin: margin,
                            padding: const BubbleEdges.all(8.0),
                            color: me ? Colors.lightBlue : Colors.lightGreen,
                            alignment: me ? Alignment.topRight : Alignment.topLeft,
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                          );
                        },
                      );
                    },
                ),
              ),
              StreamBuilder<BaseTheme>(
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
                    onSubmitted: (String value) {
                      if (value.trim().isNotEmpty) {
                        final PrivateMessageModel message = PrivateMessageModel(
                          uid: widget.uid,
                          text: value,
                          timestamp: Timestamp.now(),
                        );

                        messagingBloc.send(message, widget.recipientUid);
                        controller.clear();
                      }

                      FocusScope.of(context).requestFocus(focusNode);
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: FutureBuilder<UserModel>(
        future: userBloc.userByUid(widget.recipientUid),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Text('Conversation');
          }

          final String loadingDisplayName = snapshot.data.displayName ?? '...';
          final String displayName =
            loadingDisplayName.length > kDisplayNameMaxChararcters
            ? '${loadingDisplayName.substring(0, kDisplayNameMaxChararcters - 5)}...'
            : loadingDisplayName;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: Colors.white,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data.photoUrl ?? kDefaultAvi,
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              Text(
                displayName,
                overflow: TextOverflow.ellipsis,
              ),
              if (snapshot.data.verified)
              const VerifiedBadge(
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          );
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(MdiIcons.playlistRemove),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Clear Conversation'),
                content: const Text('Are you sure you want to clear this conversation?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      DialogHelper.instance().showWaitingDialog(
                        context: context,
                        title: 'Clearing conversation...',
                      );

                      await messagingBloc.clear(widget.recipientUid);
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                    child: const Text(
                      'Yes, clear',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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
            'Messages appear here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
