import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    Key key,
    @required this.model,
  }) : super(key: key);
  
  final FriendModel model;

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserBloc();

    return AspectRatio(
      aspectRatio: 1.0,
      child: FutureBuilder<UserModel>(
        future: userBloc.userByUid(model.uid),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final UserModel friend = snapshot.data;
          Widget content;

          if (model.pending) {
            if (model.outgoing) {
              content = Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                color: Colors.black54,
                child: Text(
                  sprintf(kFriendRequestPending, <String>[friend.displayName]),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            } else {
              content = Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                color: Colors.black54,
                child: Text(
                  sprintf(kFriendHasRequested, <String>[friend.displayName]),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
          } else {

          }

          return GestureDetector(
            onTap: () {
              if (model.pending) {
                // TODO(itsprof): show dialog to confirm or deny the request
              } else {
                Routes.router.navigateTo(
                  context,
                  'profile/${friend.uid}',
                  transition: TransitionType.inFromBottom
                );
              }
            },
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: friend.photoUrl ?? kDefaultAvi,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: content,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}