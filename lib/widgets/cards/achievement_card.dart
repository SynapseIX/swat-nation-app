import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/achievements_bloc.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/badge_model.dart';
import 'package:swat_nation/utils/date_helper.dart';

/// Represents an achievement card.
class AchievementCard extends StatelessWidget {
  const AchievementCard({
    Key key,
    @required this.model,
    @required this.uid,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.sliver = false,
  }) : super(key: key);
  
  final AchievementModel model;
  final String uid;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final AchievementsBloc bloc = AchievementsBloc(uid: uid);

    final Widget card = AspectRatio(
      aspectRatio: 3.0 / 4.0,
      child: GestureDetector(
        onTap: () => _showDetails(context, bloc, model),
        child: Container(
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            semanticContainer: true,
            child: FutureBuilder<BadgeModel>(
              future: bloc.badgeWithPath(model.badge.path),
              builder: (BuildContext context, AsyncSnapshot<BadgeModel> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return CachedNetworkImage(
                  imageUrl: snapshot.data.imageUrl,
                  fadeInDuration: const Duration(milliseconds: 300),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }

  void _showDetails(BuildContext context, AchievementsBloc bloc, AchievementModel model) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final String unlocked = humanizeTimestamp(model.unlocked, 'MMMM d, yyyy');

        return Dialog(
          child: FutureBuilder<BadgeModel>(
            future: bloc.badgeWithPath(model.badge.path),
            builder: (BuildContext context, AsyncSnapshot<BadgeModel> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final BadgeModel badge = snapshot.data;
              return Stack(
                children: <Widget>[
                  Container(
                    width: 300.0,
                    height: 400.0,
                    child: CachedNetworkImage(
                      imageUrl: badge.imageUrl,
                      fadeInDuration: const Duration(milliseconds: 300),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 300.0,
                    height: 400.0,
                    padding: const EdgeInsets.all(32.0),
                    color: Colors.black.withAlpha(192),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            badge.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                MdiIcons.heart,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '${badge.points}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            badge.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Unlocked: $unlocked',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        );
      }
    );
  }
}
