import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    Key key,
    @required this.model,
    this.onTap
  }) : super(key: key);
  
  final FriendModel model;
  final VoidCallback onTap;

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
          
          if (model.accepted) {
            content = Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisSize: MainAxisSize.min,
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
          } else {
            content = Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.black54,
              child: model.incoming
                ? Text(
                    sprintf(kFriendHasRequested, <String>[friend.displayName]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const Text(
                    kFriendRequestPending,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            );
          }

          return GestureDetector(
            onTap: onTap,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.lightGreenAccent,
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