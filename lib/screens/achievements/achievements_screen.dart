import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/achievements_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/widgets/cards/achievement_card.dart';

/// Screen to display a collection of unlocked achievements
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    Key key,
    @required this.user,
    this.me = false,
  }) : super(key: key);

  final UserModel user;
  final bool me;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final UserBloc bloc = UserBloc();
        final String uid = parameters['uid'].first;
        final bool me = parameters['me'].first == 'true';

        return FutureBuilder<UserModel>(
          future: bloc.userByUid(uid),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            return AchievementsScreen(
              user: snapshot.data,
              me: me,
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final AchievementsBloc bloc = AchievementsBloc(uid: user.uid);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            title: me
              ? const Text('My Achievements')
              : Text('${user.displayName}\'s Achievements'),
          ),

          StreamBuilder<List<AchievementModel>>(
            stream: bloc.unlockedAchievements,
            builder: (BuildContext context, AsyncSnapshot<List<AchievementModel>> snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(child: SizedBox());
              }

              return SliverGrid.count(
                crossAxisCount: kAchievementColumnCount,
                childAspectRatio: 3.0 / 4.0,
                children: snapshot.data.map((AchievementModel model) {
                  return AchievementCard(
                    key: UniqueKey(),
                    model: model,
                    uid: user.uid,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
