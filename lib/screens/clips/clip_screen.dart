import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/models/clip_info_model.dart';
import 'package:video_player/video_player.dart';

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

            return Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      overlayOpacity = overlayOpacity == 1.0 ? 0.0 : 1.0;
                    }
                  });
                },
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Stack(
                    children: <Widget>[
                      Center(
                        child: AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: Stack(
                            children: <Widget>[
                              VideoPlayer(controller),
                              AnimatedOpacity(
                                opacity: overlayOpacity,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  color: Colors.black54,
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: FlatButton(
                                          child: playbackStateIcon,
                                          onPressed: () async {
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
                                        ),
                                      ),
                                      if (!stopped)
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: VideoProgressIndicator(
                                          controller,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Theme.of(context).primaryColor,
                                            bufferedColor: Colors.lightBlue[50],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        child: AnimatedOpacity(
                          opacity: overlayOpacity,
                          duration: const Duration(milliseconds: 300),
                          child: SafeArea(
                            child: IconButton(
                              icon: const Icon(MdiIcons.close, color: Colors.white,),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
