import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';

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
  UserBloc userBloc;

  @override
  void initState() {
    userBloc = UserBloc();
    super.initState();
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: null,
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
            ],
          );
        },
      ),
    );
  }
}
