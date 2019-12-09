import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/blocked_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/blocked_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

/// Represents the blocked users screen for the authenticated user.
class BlockedScreen extends StatefulWidget {
  const BlockedScreen({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        return BlockedScreen(
          uid: uid,
        );
      }
    );
  }

  @override
  _BlockedScreenState createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  BlockedBloc blockedBloc;
  UserBloc userBloc;
  @override
  void initState() {
    blockedBloc = BlockedBloc(uid: widget.uid);
    userBloc = UserBloc();
    super.initState();
  }

  @override
  void dispose() {
    blockedBloc.dispose();
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: StreamBuilder<List<BlockedModel>>(
        stream: blockedBloc.allBlockedUsers,
        builder: (BuildContext context, AsyncSnapshot<List<BlockedModel>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyState();
          }
          
          final List<BlockedModel> data = snapshot.data;
          
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final BlockedModel model = data[index];
              
              return FutureBuilder<UserModel>(
                future: userBloc.userByUid(model.uid),
                builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final UserModel user = snapshot.data;
                  final String blockedDate
                    = humanizeTimestamp(model.dateBlocked, 'MMM d, yyyy hh:mm a');

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
                    subtitle: Text('Blocked on $blockedDate'),
                    trailing: const Icon(MdiIcons.accountOff),
                    onTap: () => _showOptions(context, model, user),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showOptions(BuildContext context, BlockedModel model, UserModel user) {
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
                    color: Colors.green,
                    onPressed: () {
                      blockedBloc.unblock(model.uid);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Unblock',
                      style: TextStyle(color: Colors.white),
                    ),
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
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Icon(
            MdiIcons.accountOff,
            size: 80.0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Blocked users appear here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
