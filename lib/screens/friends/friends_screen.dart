import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/friends_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

/// Represents the friend list screen for the authenticated user.
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        return FriendsScreen(
          uid: uid,
        );
      }
    );
  }

  @override
  State createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  FriendsBloc friendsBloc;
  UserBloc userBloc;
  
  @override
  void initState() {
    friendsBloc = FriendsBloc(uid: widget.uid);
    userBloc = UserBloc();
    super.initState();
  }
  @override
  void dispose() {
    friendsBloc.dispose();
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends'),
      ),
      body: StreamBuilder<List<FriendModel>>(
        stream: friendsBloc.allFriends,
        builder: (BuildContext context, AsyncSnapshot<List<FriendModel>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyState();
          }

          final List<FriendModel> data = snapshot.data;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final FriendModel model = data[index];

              return FutureBuilder<UserModel>(
                future: userBloc.userByUid(model.uid),
                builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const SizedBox();
                  }

                  final UserModel user = snapshot.data;
                  
                  Widget tile;
                  if (model.accepted) {
                    tile = ListTile(
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
                      subtitle: Text('Added on ${humanizeTimestamp(model.dateAdded, 'MMM d, yyyy')}'),
                      trailing: const Icon(MdiIcons.dotsHorizontal),
                      onTap: () => _showOptions(context, model, user),
                    );
                  } else {
                    tile = ListTile(
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
                      subtitle: const Text('REQUEST IS PENDING'),
                      trailing: const Icon(
                        MdiIcons.accountAlert,
                        color: Colors.amber,
                      ),
                      onTap: () => _showPendingOptions(context, model, user),
                    );
                  }

                  return tile;
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showOptions(BuildContext context, FriendModel model, UserModel user) {
    showDialog<void>(
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
                    borderRadius: BorderRadius.circular(80.0),
                    child: CachedNetworkImage(
                      imageUrl: user.photoUrl ?? kDefaultAvi,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    if (user.verified)
                    const VerifiedBadge(
                      margin: EdgeInsets.only(left: 4.0),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      friendsBloc.removeFriend(model.uid);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Remove Friend',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Routes
                        .router
                        .navigateTo(context, '/profile/${widget.uid}/${model.uid}');
                    },
                    child: const Text('View Profile'),
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showPendingOptions(BuildContext context, FriendModel model, UserModel user) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final List <Widget> options = <Widget>[];

        options.addAll(<Widget>[
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
              borderRadius: BorderRadius.circular(80.0),
              child: CachedNetworkImage(
                imageUrl: user.photoUrl ?? kDefaultAvi,
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                user.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              if (user.verified)
              const VerifiedBadge(
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
        ]);

        if (model.incoming) {
          options.addAll(<Widget>[
            Container(
              width: double.infinity,
              height: 40.0,
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  friendsBloc.processFriendRequest(model.uid, true);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Accept Request',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Container(
              width: double.infinity,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  friendsBloc.removeFriend(model.uid);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Deny Request',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
          ]);
        } else {
          options.addAll(<Widget>[
            Container(
              width: double.infinity,
              height: 40.0,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  friendsBloc.removeFriend(model.uid);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel Request',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
          ]);
        }

        options.add(
          Container(
            width: double.infinity,
            height: 40.0,
            child: RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ),
        );

        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options,
            ),
          ),
        );
      }
    );
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
            MdiIcons.accountMultiple,
            size: 80.0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Friends appear here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
