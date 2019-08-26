import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/models/clip_info_model.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/clip_helper.dart';
import 'package:swat_nation/utils/date_helper.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

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
    final ClipsBloc clipsBloc = ClipsBloc();

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
            color: Colors.cyanAccent,
            child: GestureDetector(
              // TODO(itsprof): play insterstitial if not premium
              onTap: () async {
                DialogHelper.instance().showWaitingDialog(
                  context: context,
                  title: 'Loading clip...',
                );

                await clipsBloc.reseed(model);

                Navigator.pop(context);
                Routes.router.navigateTo(context, 'clip/${model.uid}');
              },
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
                          placeholder: (BuildContext context, String url) {
                            return Center(child: const CircularProgressIndicator());
                          },
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
                      MdiIcons.play,
                      color: Colors.white,
                      size: 50.0,
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
                            fontSize: 20.0
                          ),
                        ),
                        FutureBuilder<UserModel>(
                          future: userBloc.userByUid(model.author),
                          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Gameplay by ${snapshot.data.displayName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
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
                          'Created ${humanizeTimestamp(model.createdAt, 'MMMM dd, yyyy')}',
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
      ),
    );

    return sliver ? SliverToBoxAdapter(child: card) : card;
  }
}
