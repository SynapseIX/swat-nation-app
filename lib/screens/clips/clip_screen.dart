import 'package:auto_orientation/auto_orientation.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:sprintf/sprintf.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/clip_model_proxy.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/clip_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

/// Represents the screen that constains the video player for clips.
class ClipScreen extends StatefulWidget {
  const ClipScreen({
    Key key,
    @required this.model,
  }) : super(key: key);
  
  final ClipModelProxy model;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final ClipsBloc bloc = ClipsBloc();
        final String uid = parameters['uid'].first;

        return FutureBuilder<ClipModel>(
          future: bloc.clipByUid(uid),
          builder: (BuildContext context, AsyncSnapshot<ClipModel> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return _EmptyState();
            }

            final ClipModel clip = snapshot.data;
            return FutureBuilder<ClipModelProxy>(
              future: extractClipInfo(clip.link),
              builder: (BuildContext context, AsyncSnapshot<ClipModelProxy> snapshot) {
                if (!snapshot.hasData) {
                  return _EmptyState();
                }
                
                final ClipModelProxy clipInfo = snapshot.data;
                clipInfo.author = clip.author;
                clipInfo.title = clip.title;
                return ClipScreen(model: clipInfo);
              },
            );
          },
        );
      }
    );
  }

  @override
  _ClipScreenState createState() => _ClipScreenState();
}

class _ClipScreenState extends State<ClipScreen>
  with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  VideoPlayerController controller;
  Future<void> initialized;
  
  double overlayOpacity;
  bool stopped;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.model.videoUrl);
    controller.addListener(_listener);
    initialized = controller.initialize();

    overlayOpacity = 1.0;
    stopped = false;

    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

    Wakelock.enable();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('Re-adding listener');
        controller.addListener(_listener);
        break;
      case AppLifecycleState.paused:
        print('Removing listener');
        controller.removeListener(_listener);
        break;
      default:
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();

    Wakelock.disable();
    AutoOrientation.portraitUpMode();
    super.dispose();
  }

  void _listener() {
    final Duration duration = controller.value.duration;
    final Duration position = controller.value.position;
    final bool isPlaying = controller.value.isPlaying;
    final bool playbackStopped = position == duration && !isPlaying;
    
    if (playbackStopped && mounted) {
      setState(() {
        stopped = true;
        overlayOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: FutureBuilder<void>(
        future: initialized,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: overlayOpacity == 1.0
                ? AppBar(
                  backgroundColor: Colors.black,
                  title: Text(
                    widget.model.title ?? 'Watching a Clip',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: IconButton(
                    icon: const Icon(MdiIcons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(MdiIcons.share),
                      onPressed: () async {
                        final UserBloc userBloc = UserBloc();
                        final UserModel user = await userBloc.userByUid(widget.model.author);
                        final String shareText = sprintf(
                          kShareClip,
                          <String>[user.displayName, widget.model.link],
                        );
                        
                        await Share.share(shareText);
                        userBloc.dispose();
                      },
                    ),
                  ],
                )
                : null,
              body: Stack(
                children: <Widget>[
                  Center(
                    child: AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: Stack(
                        children: <Widget>[
                          VideoPlayer(controller),
                          _ControlsOverlay(
                            controller: controller,
                            model: widget.model,
                            opacity: overlayOpacity,
                            stopped: stopped,
                            onTapPlayback: () async {
                              if (stopped) {
                                await controller.initialize();
                                await controller.play();

                                setState(() {
                                  stopped = false;
                                  overlayOpacity = 0.0;
                                });
                              } else {
                                controller.value.isPlaying
                                    ? await controller.pause()
                                    : await controller.play();
                                
                                setState(() {
                                  overlayOpacity = controller.value.isPlaying ? 0.0 : 1.0;
                                });
                              }
                            },
                            onTapOverlay: () {
                              setState(() {
                                overlayOpacity = controller.value.isPlaying 
                                  && overlayOpacity == 1.0 
                                    ? 0.0 
                                    : 1.0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return _EmptyState();
        },
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({
    @required this.controller,
    @required this.model,
    @required this.opacity,
    @required this.stopped,
    this.onTapPlayback,
    this.onTapOverlay,
  });
  
  final VideoPlayerController controller;
  final ClipModelProxy model;
  final double opacity;
  final bool stopped;
  final VoidCallback onTapPlayback;
  final VoidCallback onTapOverlay;

  @override
  Widget build(BuildContext context) {
    Widget playbackStateIcon;
    if (stopped) {
      playbackStateIcon = const Icon(
        MdiIcons.replay,
        color: Colors.white,
        size: 80.0,
      );
    } else {
      playbackStateIcon = Icon(
        controller.value.isPlaying ? MdiIcons.pause : MdiIcons.play,
        color: Colors.white,
        size: 80.0,
      );
    }

    final VideoProgressIndicator progressIndicator = VideoProgressIndicator(
      controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor: Theme.of(context).primaryColor,
        bufferedColor: Colors.lightBlue[50],
      ),
    );

    return GestureDetector(
      onTap: onTapOverlay,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black.withAlpha(192),
          child: Stack(
            children: <Widget>[
              Center(
                child: FlatButton(
                  child: playbackStateIcon,
                  onPressed: onTapPlayback,
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Source: ${model.link}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textScaleFactor: 0.5,
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (!stopped)
                    progressIndicator,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 8.0),
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
