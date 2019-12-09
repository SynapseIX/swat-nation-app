import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represents the ranking tab screen.
class RankingTab extends StatefulWidget implements BaseTab {
  const RankingTab({ Key key }) : super(key: key);

  @override
  _RankingTabState createState() => _RankingTabState();

  @override
  IconData get icon => MdiIcons.medal;

  @override
  String get title => 'Ranking';
}

class _RankingTabState extends State<RankingTab> with AutomaticKeepAliveClientMixin {
  UserBloc bloc;
  
  @override
  void initState() {
    bloc = UserBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${humanizeDateTime(DateTime.now(), 'MMMM yyyy')} Ranking'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              MdiIcons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: bloc.monthlyRanking,
        builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyState();
          }

          final List<UserModel> data = snapshot.data;
          return ListView.separated(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final UserModel model = data[index];

              Widget medal;
              const TextStyle style = TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              );

              if (index == 0) {
                medal = const Text('🥇', style: style);
              } else if (index == 1) {
                medal = const Text('🥈', style: style);
              } else if(index == 2) {
                medal = const Text('🥉', style: style);
              } else {
                medal = Text('${index + 1}', style: style);
              }

              return ListTile(
                leading: medal,
                title: Row(
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
                        borderRadius: BorderRadius.circular(40.0),
                        child: CachedNetworkImage(
                          imageUrl: model.photoUrl ?? kDefaultAvi,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          model.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (model.verified)
                        const VerifiedBadge(
                          margin: EdgeInsets.only(left: 4.0),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  '${model.monthlyScore}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                onTap: () async {
                  DialogHelper.instance().showWaitingDialog(
                    context: context,
                    title: 'Preparing...'
                  );

                  final FirebaseUser currentUser = await AuthBloc.instance().currentUser;
                  Navigator.pop(context);

                  if (currentUser == null) {
                    return DialogHelper
                      .instance()
                      .showSignInDIalog(context: context);
                  } else {
                    Routes
                      .router
                      .navigateTo(context, '/profile/${currentUser.uid}/${model.uid}');
                  }
                }
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(indent: Platform.isIOS ? 16.0 : 0.0);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            MdiIcons.medal,
            size: 80.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Ranking for ${humanizeDateTime(DateTime.now(), 'MMMM yyyy')} appears here.',
            style: const TextStyle(
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
