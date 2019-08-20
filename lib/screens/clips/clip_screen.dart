import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_info_model.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

/// Represents the screen that constains the video player for clips.
class ClipScreen extends StatefulWidget {
  const ClipScreen({
    @required this.model,
  });
  
  final ClipInfoModel model;

  @override
  State createState() => _ClipScreenState();
}

class _ClipScreenState extends State<ClipScreen> {
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
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();

    // TODO(itsprof): force orientation change natively
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ],
    );

    Wakelock.disable();
    super.dispose();
  }

  void _listener() {
    final Duration duration = controller.value.duration;
    final Duration position = controller.value.position;
    final bool isPlaying = controller.value.isPlaying;
    final bool playbackStopped = position == duration && !isPlaying;
    
    if (playbackStopped) {
      setState(() {
        stopped = true;
        overlayOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    widget.model.title ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
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
                                setState(() {
                                  controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                                  overlayOpacity = controller.value.isPlaying ? 0.0 : 1.0;
                                });
                              }
                            },
                            onTapOverlay: () {
                              setState(() {
                                if (controller.value.isPlaying) {
                                  overlayOpacity = overlayOpacity == 1.0 ? 0.0 : 1.0;
                                }
                              });

                              if (overlayOpacity == 1 && !stopped) {
                                Future<void>.delayed(
                                  kPlayerOverlayFadeAfterDuration,
                                  () {
                                    setState(() {
                                      overlayOpacity = 0.0;
                                    });
                                  },
                                );
                              }
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

          return Center(child: const CircularProgressIndicator());
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
  final ClipInfoModel model;
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
          color: Colors.black54,
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
