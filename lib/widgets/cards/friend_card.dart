import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';

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
          return GestureDetector(
            onTap: () {},
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: friend.photoUrl,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.cover,
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