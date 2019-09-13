import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/friends_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

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
            return const Center(child: CircularProgressIndicator());
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
                  return ListTile(
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
                    // TODO(itsprof): implement
                    onTap: () {},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
