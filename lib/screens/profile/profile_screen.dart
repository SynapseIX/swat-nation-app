import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:swat_nation/blocs/achievements_bloc.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/blocked_bloc.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/blocs/friends_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/friend_model.dart';
import 'package:swat_nation/models/navigation_result.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/achievement_card.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/cards/friend_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/common/view_all_card.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

enum ProfileAction { friend, unfriend, block, unblock, message, inbox, edit, report }

/// Represents the user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key key,
    @required this.model,
    @required this.myUid,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final UserBloc bloc = UserBloc();
        final String myUid = parameters['myUid'].first;
        final String uid = parameters['uid'].first;

        return FutureBuilder<UserModel>(
          future: bloc.userByUid(uid),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return ProfileScreen(
              model: snapshot.data,
              myUid: myUid,
            );
          },
        );
      }
    );
  }
  
  final UserModel model;
  final String myUid;

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AchievementsBloc achievementsBloc;
  ClipsBloc clipsBloc;
  UserBloc userBloc;
  FriendsBloc friendsBloc;
  BlockedBloc blockedBloc;
  UserModel user;

  @override
  void initState() {
    user = widget.model;
    achievementsBloc = AchievementsBloc(uid: user.uid);
    clipsBloc = ClipsBloc();
    userBloc = UserBloc();
    friendsBloc = FriendsBloc(uid: widget.myUid);
    blockedBloc = BlockedBloc(uid: widget.myUid);
    super.initState();
  }

  @override
  void dispose() {
    achievementsBloc.dispose();
    clipsBloc.dispose();
    userBloc.dispose();
    friendsBloc.dispose();
    blockedBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool me = user.uid == widget.myUid;
    
    return Scaffold(
      appBar: AppBar(
        title: me
          ? const Text('My Profile')
          : const Text('Member Profile'),
        leading: IconButton(
          icon: const Icon(MdiIcons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          _buildProfileActions(me),
        ],
      ),
      body: me
        ? _PublicBody(
            achievementsBloc: achievementsBloc,
            clipsBloc: clipsBloc,
            userBloc: userBloc,
            friendsBloc: friendsBloc,
            user: user,
            me: me,
          )
        : FutureBuilder<bool>(
            future: friendsBloc.checkFriendship(user.uid),
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              final Widget privateBody = _PrivateBody(user:user);
              final Widget publicBody = _PublicBody(
                achievementsBloc: achievementsBloc,
                clipsBloc: clipsBloc,
                userBloc: userBloc,
                friendsBloc: friendsBloc,
                user: user,
                me: me,
              );

              if (snapshot.hasData && snapshot.data) {
                return publicBody;
              } else {
                return user.private
                  ? privateBody
                  : publicBody;
              }
            },
          ),
    );
  }

  Future<void> _navigateToEdit() async {
    final UserModel updatedUser = await Routes
      .router
      .navigateTo(context, '/edit-profile/${widget.myUid}');

    if (updatedUser != null) {
      setState(() {
        user = updatedUser;
      });
    }
  }

  // TODO(itsprof): add remaining actions and all required validations
  Widget _buildProfileActions(bool me) {
    if (me) {
      return PopupMenuButton<ProfileAction>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ProfileAction>>[
          PopupMenuItem<ProfileAction>(
            value: ProfileAction.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(MdiIcons.accountEdit),
                SizedBox(width: 8.0),
                Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem<ProfileAction>(
            value: ProfileAction.inbox,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(MdiIcons.email),
                SizedBox(width: 8.0),
                Text('Inbox'),
              ],
            ),
          ),
          PopupMenuItem<ProfileAction>(
            value: ProfileAction.block,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(MdiIcons.accountOff),
                SizedBox(width: 8.0),
                Text('Blocked Users'),
              ],
            ),
          ),
        ],
        onSelected: (ProfileAction action) {
          switch (action) {
            case ProfileAction.edit:
              _navigateToEdit();
              break;
            case ProfileAction.inbox:
              Routes.router.navigateTo(context, '/inbox/${widget.myUid}');
              break;
            case ProfileAction.block:
              Routes.router.navigateTo(context, '/blocked/${widget.myUid}');
              break;
            default:
              break;
          }
        },
      );
    }

    return FutureBuilder<bool>(
      future: friendsBloc.checkFriendship(user.uid),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final bool isFriend = snapshot.hasData && snapshot.data;

        return FutureBuilder<bool>(
          future: blockedBloc.checkIfUserIsBlocked(user.uid),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final bool blocked = snapshot.hasData && snapshot.data;

            return PopupMenuButton<ProfileAction>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<ProfileAction>>[
                PopupMenuItem<ProfileAction>(
                  value: isFriend ? ProfileAction.unfriend : ProfileAction.friend,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(isFriend ? MdiIcons.accountMinus : MdiIcons.accountPlus),
                      const SizedBox(width: 8.0),
                      Text(isFriend ? 'Remove friend' : 'Add friend'),
                    ],
                  ),
                ),

                if (!widget.model.private || isFriend)
                PopupMenuItem<ProfileAction>(
                  value: ProfileAction.message,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(MdiIcons.email),
                      SizedBox(width: 8.0),
                      Text('Message'),
                    ],
                  ),
                ),
                PopupMenuItem<ProfileAction>(
                  value: blocked ? ProfileAction.unblock : ProfileAction.block,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(MdiIcons.accountOff),
                      const SizedBox(width: 8.0),
                      Text(blocked ? 'Unblock' : 'Block'),
                    ],
                  ),
                ),
                PopupMenuItem<ProfileAction>(
                  value: ProfileAction.report,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(MdiIcons.alertCircle),
                      SizedBox(width: 8.0),
                      Text('Report'),
                    ],
                  ),
                ),
              ],
              onSelected: (ProfileAction action) async {
                // TODO(itsprof): implement actions
                switch (action) {
                  case ProfileAction.friend:
                    DialogHelper.instance().showWaitingDialog(
                      context: context,
                      title: 'Sending friend request...',
                    );

                    try {
                      await friendsBloc.sendFriendRequest(user.uid);
                      Navigator.pop(context);

                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Sent Request'),
                          content: Text(sprintf(kFriendRequestSent, <String>[user.displayName])),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context)
                                ..pop()
                                ..pop(),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      Navigator.pop(context);
                      DialogHelper.instance().showErrorDialog(
                        context: context,
                        title: 'Can\'t Send Request',
                        message: error ?? 'Your friend request can\'t be sent. Please try again later.'
                      );
                    }
                    break;
                  case ProfileAction.unfriend:
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Remove Friend'),
                        content: Text(sprintf(kFriendRemove, <String>[user.displayName])),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              try {
                                await friendsBloc.removeFriend(user.uid);
                                setState(() {});
                              } catch (error) {
                                DialogHelper.instance().showErrorDialog(
                                  context: context,
                                  title: 'Can\'t Remove',
                                  message: 'Friend can\'t be removed. Please try again later.'
                                );
                              }
                            },
                            child: const Text(
                              'Remove',
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
                    break;
                  case ProfileAction.message:
                    DialogHelper.instance().showWaitingDialog(
                      context: context,
                      title: 'Preparing...',
                    );

                    final bool blocked = await blockedBloc.checkIfBlocked(user.uid);
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
                          .navigateTo(context, '/conversation/${widget.myUid}/${user.uid}');
                      } catch (error) {
                        Navigator.pop(context);
                        DialogHelper.instance().showErrorDialog(
                          context: context,
                          title: 'Can\'t Message',
                          message: error ?? 'Can\'t message this user. Please try again later.'
                        );
                      } 
                    }
                    break;
                  case ProfileAction.block:
                    DialogHelper.instance().showWaitingDialog(
                      context: context,
                      title: 'Blocking user...',
                    );

                    try {
                      await blockedBloc.block(user.uid);
                      Navigator.pop(context);
                      setState(() {});

                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text('User has been blocked.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      Navigator.pop(context);
                      DialogHelper.instance().showErrorDialog(
                        context: context,
                        title: 'Can\'t Send Request',
                        message: error ?? 'Can\'t block user. Please try again later.'
                      );
                    }
                    break;
                  case ProfileAction.unblock:
                    DialogHelper.instance().showWaitingDialog(
                      context: context,
                      title: 'Unblocking user...',
                    );

                    try {
                      await blockedBloc.unblock(user.uid);
                      Navigator.pop(context);
                      setState(() {});

                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text('User has been unblocked.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      Navigator.pop(context);
                      DialogHelper.instance().showErrorDialog(
                        context: context,
                        title: 'Can\'t Send Request',
                        message: error ?? 'Can\'t unblock user. Please try again later.'
                      );
                    }
                    break;
                  default:
                    break;
                }
              },
            );
          },
        );
      }
    );
  }
}

class _PublicHeader extends StatelessWidget {
  const _PublicHeader({
    @required this.user,
    this.me = false,
  });

  final UserModel user;
  final bool me;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            user.headerUrl ?? kDefaultProfileHeader,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.black54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _navigateToImageViewer(
                    context: context,
                    imageUrl: user.photoUrl ?? kDefaultAvi,
                  ),
                  child: Container(
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
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          user.displayName.length > 15
                            ? '${user.displayName.substring(0, 10)}...'
                            : user.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.verified)
                        const VerifiedBadge(
                          margin: EdgeInsets.only(left: 4.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Joined ${humanizeTimestamp(user.createdAt, 'MMMM yyyy')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          MdiIcons.heart,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${user.score}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (user.bio != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                user.bio,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            if (me)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: user.uid));
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: const Text('Your Support ID has been copied.'),
                  ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16.0),
                    child: const Text(
                      'Support ID:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      user.uid,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _navigateToImageViewer({
    @required BuildContext context,
    @required String imageUrl,
  }) {
    final List<int> bytes = utf8.encode(imageUrl);
    final String encodedUrl = base64.encode(bytes);
    return Routes.router.navigateTo(context, '/image-viewer/$encodedUrl');
  }
}

class _PrivateHeader extends StatelessWidget {
  const _PrivateHeader({
    @required this.user,
  });

  final UserModel user;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: CachedNetworkImageProvider(user.headerUrl ?? kDefaultProfileHeader),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0x88000000),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => _navigateToImageViewer(
              context: context,
              imageUrl: user.photoUrl ?? kDefaultAvi,
            ),
            child: Container(
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
          ),
          const SizedBox(width: 8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                user.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.verified)
              const VerifiedBadge(
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> _navigateToImageViewer({
    @required BuildContext context,
    @required String imageUrl,
  }) {
    final List<int> bytes = utf8.encode(imageUrl);
    final String encodedUrl = base64.encode(bytes);
    return Routes.router.navigateTo(context, '/image-viewer/$encodedUrl');
  }
}

class _PublicBody extends StatelessWidget {
  const _PublicBody({
    @required this.achievementsBloc,
    @required this.clipsBloc,
    @required this.userBloc,
    @required this.friendsBloc,
    @required this.user,
    this.me = false,
  });

  final AchievementsBloc achievementsBloc;
  final ClipsBloc clipsBloc;
  final UserBloc userBloc;
  final FriendsBloc friendsBloc;
  final UserModel user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // Profile header
        _PublicHeader(user: user, me: me),

        // Socials
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16.0,
            runSpacing: 4.0,
            children: <Widget>[
              if (user.gamertag != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.xbox),
                label: Text(user.gamertag),
                onPressed: () => openUrl('$kGamertag${user.gamertag}'),
              ),

              if (user.twitter != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.twitter),
                label: Text(user.twitter),
                onPressed: () => openUrl('https://twitter.com/${user.twitter}'),
              ),

              if (user.instagram != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.instagram),
                label: Text(user.instagram),
                onPressed: () => openUrl('https://instagram.com/${user.instagram}'),
              ),

              if (user.facebook != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.facebook),
                label: Text(user.facebook),
                onPressed: () => openUrl('https://facebook.com/${user.facebook}'),
              ),

              if (user.mixer != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.mixer),
                label: Text(user.mixer),
                onPressed: () => openUrl('https://mixer.com/${user.mixer}'),
              ),

              if (user.twitch != null)
              OutlineButton.icon(
                icon: const Icon(MdiIcons.twitch),
                label: Text(user.twitch),
                onPressed: () => openUrl('https://twitch.tv/${user.twitch}'),
              ),
            ],
          ),
        ),

        if (me && user.provider == UserProvider.email)
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: const Text(
                    'Change Email',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () async {
                    final NavigationResult result = await Routes
                      .router
                      .navigateTo(context, Routes.changeEmail);
                    
                    if (result != null) {
                      String message;
                      if (result.payload != null) {
                        message = result.payload;
                      }
                      if (result.error != null) {
                        message = result.error;
                      }

                      Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text(message),
                      ));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: RaisedButton(
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () async {
                    DialogHelper.instance().showWaitingDialog(
                      context: context,
                      title: 'Requesting password reset...'
                    );

                    final PlatformException error = await AuthBloc
                      .instance().requestPasswordReset();

                    Navigator.pop(context);
                    
                    final String message = error == null
                      ? kResetPasswordRequestSent
                      : error.message;
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(message),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),

        // Custom logo request
        if (me)
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: RaisedButton(
            // TODO(itsprof): implement
            onPressed: () {},
            child: const Text('Request Custom Logo'),
          ),
        ),

        // Friends
        if (me)
        StreamBuilder<List<FriendModel>>(
          stream: friendsBloc.allFriends,
          builder: (BuildContext context, AsyncSnapshot<List<FriendModel>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox();
            }
            
            final Widget Function(FriendModel) cardMapper = (FriendModel model) {
              return FriendCard(
                key: UniqueKey(),
                model: model,
                onTap: () async {
                  DialogHelper.instance().showWaitingDialog(context: context);

                  final FirebaseUser myself = await AuthBloc.instance().currentUser;
                  final UserModel friend = await userBloc.userByUid(model.uid);
                  Navigator.pop(context);

                  if (model.accepted) {
                    Routes.router.navigateTo(context, '/profile/${myself.uid}/${model.uid}');
                  } else {
                    if (model.incoming) {
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
                                        imageUrl: friend.photoUrl ?? kDefaultAvi,
                                        width: 80.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                        fadeInDuration: const Duration(milliseconds: 300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Incoming Friend Request',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(sprintf(kFriendHasRequested, <String>[friend.displayName])),
                                  const SizedBox(height: 24.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        friendsBloc.processFriendRequest(model.uid, true);
                                        Navigator.pop(context);
                                      },
                                      color: Colors.green,
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        friendsBloc.removeFriend(model.uid);
                                        Navigator.pop(context);
                                      },
                                      color: Colors.red,
                                      child: const Text(
                                        'Ignore',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
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
                    } else {
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
                                        imageUrl: friend.photoUrl ?? kDefaultAvi,
                                        width: 80.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                        fadeInDuration: const Duration(milliseconds: 300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Pending Friend Request',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(kFriendRequestPending),
                                  const SizedBox(height: 24.0),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        friendsBloc.removeFriend(model.uid);
                                        Navigator.pop(context);
                                      },
                                      color: Colors.red,
                                      child: const Text(
                                        'Cancel Request',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
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
                },
              );
            };

            final bool largeList = snapshot.data.length > kMaxFriendsCards;
            final List<Widget> cards = largeList
              ? snapshot.data
                .sublist(0, kMaxFriendsCards)
                .map(cardMapper).toList()
              : snapshot.data
                .map(cardMapper).toList();
                
            cards.add(ViewAllCard(
              text: 'Manage',
              onTap: () => Routes.router.navigateTo(context, '/my-friends/${user.uid}'),
            ));

            return CardSection(
              header: const TextHeader('Friends'),
              cardList: HorizontalCardList(
                cards: cards,
              ),
            );
          },
        ),

        // Achievements
        StreamBuilder<List<AchievementModel>>(
          stream: achievementsBloc.unlockedAchievements,
          builder:
            (BuildContext context, AsyncSnapshot<List<AchievementModel>> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final Widget Function(AchievementModel) cardMapper = (AchievementModel model) {
                return AchievementCard(
                  key: UniqueKey(),
                  model: model,
                  uid: user.uid,
                );
              };

              final bool largeList = snapshot.data.length > kMaxAchievementCards;
              final List<Widget> cards = largeList
                ? snapshot.data
                  .sublist(0, kMaxAchievementCards)
                  .map(cardMapper).toList()
                : snapshot.data
                  .map(cardMapper).toList();

              if (cards.length > kMaxAchievementCards) {
                cards.add(ViewAllCard(
                  onTap: () => Routes
                    .router
                    .navigateTo(context, '/achievements/${user.uid}/$me'),
                ));
              }

              return CardSection(
                header: const TextHeader('Achievements'),
                cardList: HorizontalCardList(
                  cards: cards,
                ),
              );
            },
        ),

        // Clips
        StreamBuilder<List<ClipModel>>(
          stream: clipsBloc.allClipsForUser(user.uid),
          builder: (BuildContext context, AsyncSnapshot<List<ClipModel>> snapshot) {
            final Widget Function(ClipModel) cardMapper = (ClipModel model) {
              return ClipCard(
                key: ValueKey<String>(model.uid),
                model: model,
              );
            };

            Widget clipsContent;
            int numberOfClips = 0;

            if (snapshot.hasData) {
              numberOfClips = snapshot.data.length;
              final bool largeList = numberOfClips > kNoSubClipLimit;
              final List<Widget> cards = largeList
                ? snapshot.data
                  .sublist(0, kNoSubClipLimit)
                  .map(cardMapper).toList()
                : snapshot.data
                  .map(cardMapper).toList();
              
              // View All
              cards.add(ViewAllCard(
                text: me ? 'Manage' : 'View All',
                onTap: () {
                  Routes.router.navigateTo(
                    context,
                    'clip/all/${user.uid}/${user.displayName}/$me',
                  );
                },
              ));

              clipsContent = HorizontalCardList(cards: cards);
            } else {
              clipsContent = Container(
                height: 200.0,
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: me  
                    ? () {
                        // TODO(itsprof): validate if subscriber
                        const bool subscriber = true;
                        final DialogHelper helper = DialogHelper.instance();

                        if (subscriber) {
                          if (numberOfClips < kSubClipLimit) {
                            Routes.router.navigateTo(context, 'clip/create/${user.uid}');
                          } else {
                            helper.showErrorDialog(
                              context: context,
                              title: 'Can\'t Add More Clips',
                              message: kSubClipLimitMessage,
                            );
                          }
                        } else {
                          if (numberOfClips < kNoSubClipLimit) {
                            Routes.router.navigateTo(context, 'clip/create/${user.uid}');
                          } else {
                            helper.showSubscribeDialog(
                              context: context,
                              message: kNoSubClipLimitMessage,
                            );
                          }
                        }
                      }
                    : null,
                  child: Card(
                    child: Center(
                      child: Text(
                        me
                        ? '$kNoClipsCopy\nTap to add a clip.'
                        : kNoClipsCopy,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const TextHeader('Clips'),
                clipsContent,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PrivateBody extends StatelessWidget {
  const _PrivateBody({
    @required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Profile header
        _PrivateHeader(user: user),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  MdiIcons.lock,
                  size: 120.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'This profile is private',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
