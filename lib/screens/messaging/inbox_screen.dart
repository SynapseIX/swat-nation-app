import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/blocked_bloc.dart';
import 'package:swat_nation/blocs/messaging_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/conversation_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represents the inbox screen for the authenticated user.
class InboxScreen extends StatefulWidget {
  const InboxScreen({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        return InboxScreen(
          uid: uid,
        );
      }
    );
  }

  @override
  State createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  MessagingBloc messagingBloc;
  UserBloc userBloc;
  BlockedBloc blockedBloc;
  
  @override
  void initState() {
    messagingBloc = MessagingBloc(uid: widget.uid);
    userBloc = UserBloc();
    blockedBloc = BlockedBloc(uid: widget.uid);
    super.initState();
  }
  @override
  void dispose() {
    messagingBloc.dispose();
    userBloc.dispose();
    blockedBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: StreamBuilder<List<ConversationModel>>(
        stream: messagingBloc.conversations,
        builder: (BuildContext context, AsyncSnapshot<List<ConversationModel>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyState();
          }

          final List<ConversationModel> data = snapshot.data;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final ConversationModel model = data[index];

              return FutureBuilder<UserModel>(
                future: userBloc.userByUid(model.recipientUid),
                builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const SizedBox();
                  }

                  final UserModel user = snapshot.data;
                  
                  return Dismissible(
                    key: ValueKey<String>(model.recipientUid),
                    direction: DismissDirection.endToStart,
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl: user.photoUrl ?? kDefaultAvi,
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user.verified)
                          const VerifiedBadge(
                            margin: EdgeInsets.only(left: 4.0),
                          ),
                        ],
                      ),
                      subtitle: Text('Started on ${humanizeTimestamp(model.createdAt, 'MMM d, yyyy')}'),
                      trailing: const Icon(MdiIcons.chevronRight),
                      onTap: () => _navigateToConversation(model),
                    ),
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          MdiIcons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) async {
                      data.removeAt(index);
                      messagingBloc.removeConversation(model.recipientUid);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _navigateToConversation(ConversationModel model) async {
    DialogHelper.instance().showWaitingDialog(
      context: context,
      title: 'Preparing...',
    );

    final bool blocked = await blockedBloc.checkIfBlocked(model.recipientUid);
    if (blocked) {
      Navigator.pop(context);
        DialogHelper.instance().showErrorDialog(
          context: context,
          title: 'Can\'t Message',
          message: 'Can\'t message this user. Please try again later.'
        );
    } else {
      try {
        Navigator.pop(context);
        Routes
          .router
          .navigateTo(context, '/conversation/${widget.uid}/${model.recipientUid}');
      } catch (error) {
        Navigator.pop(context);
        DialogHelper.instance().showErrorDialog(
          context: context,
          title: 'Can\'t Message',
          message: error ?? 'Can\'t message this user. Please try again later.'
        );
      } 
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
            MdiIcons.inbox,
            size: 80.0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Your inbox is empty.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          )
        ],
      ),
    );
  }
}
