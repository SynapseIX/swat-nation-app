import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/models/clip_info_model.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/clip_helper.dart';
import 'package:swat_nation/utils/date_helper.dart';

/// Creates a card that represents a clip.
class ClipCard extends StatelessWidget {
  const ClipCard({
    Key key,
    @required this.model,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.width = double.infinity,
    this.height = double.infinity,
    this.sliver = false,
  }) : super(key: key);

  final ClipModel model;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserBloc();

    final Widget card = AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.lightBlue,
            child: Stack(
              children: <Widget>[
                FutureBuilder<ClipInfoModel>(
                  future: extractClipInfo(model.link),
                  builder: (BuildContext context, AsyncSnapshot<ClipInfoModel> snapshot) {
                    if (snapshot.hasData) {
                      return CachedNetworkImage(
                        imageUrl: snapshot.data.thumbnail,
                        width: double.infinity,
                        height: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 300),
                        fit: BoxFit.cover,
                      );
                    }

                    return const SizedBox();
                  },
                ),
                Container(
                  color: Colors.black54,
                ),
                Center(
                  child: const Icon(
                    MdiIcons.playCircleOutline,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ),
                Positioned(
                  left: 8.0,
                  bottom: 8.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        model.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0
                        ),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: userBloc.userByUid(model.author),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            final UserModel user = UserModel.fromSnapshot(snapshot.data);
                            
                            return Text(
                              'Gameplay by ${user.displayName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        MdiIcons.calendar,
                        color: Colors.white,
                        size: 17.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        humanizeTimestamp(model.createdAt, 'MMMM dd, yyyy'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
