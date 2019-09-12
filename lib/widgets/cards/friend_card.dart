import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:swat_nation/blocs/friends_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    Key key,
    @required this.model,
    @required this.bloc,
  }) : super(key: key);
  
  final FriendModel model;
  final FriendsBloc bloc;

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
            content = Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        friend.displayName.length > 15
                          ? '${friend.displayName.substring(0, 10)}...'
                          : friend.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (friend.verified)
                      const VerifiedBadge(
                        margin: EdgeInsets.only(left: 4.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      const Icon(
                        MdiIcons.accountMultiple,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        humanizeTimestamp(model.dateAdded, 'MMM d, yyyy'),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return GestureDetector(
            onTap: () {
              if (model.pending) {
                if (model.outgoing) {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Friend Request'),
                      content: const Text('Do you want to cancel this friend request?'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text(
                            'Cancel Request',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            final bool removed = await bloc.removeFriend(model.uid);
                            print('Removed? $removed');
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text('Dismiss'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Friend Request'),
                      content: Text('${friend.displayName} has requested to be your friend.'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () async {
                            await bloc.processFriendRequest(model, false);
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text(
                            'Deny',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            await bloc.removeFriend(model.uid);
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text('Dismiss'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
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