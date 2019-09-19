import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Screen that lists all clips from a user.
class AllClipsScreen extends StatefulWidget {
  const AllClipsScreen({
    Key key,
    @required this.uid,
    @required this.displayName,
    this.me = false
  }) : super(key: key);

  final String uid;
  final String displayName;
  final bool me;

  static Handler routeHandler() {
    return Handler(
      type: HandlerType.route,

      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        final String displayName = parameters['displayName'].first;
        final bool me = parameters['me'].first == 'true';

        return AllClipsScreen(
          uid: uid,
          displayName: displayName,
          me: me,
        );
      }
    );
  }

  @override
  State createState() => _AllClipsScreenState();
}

class _AllClipsScreenState extends State<AllClipsScreen> {
  ClipsBloc bloc;
  List<ClipModel> data;

  @override
  void initState() {
    bloc = ClipsBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.me
          ? const Text('My Clips')
          : Text('${widget.displayName}\'s Clips'),
      ),
      body: StreamBuilder<List<ClipModel>>(
        stream: bloc.allClipsForUser(widget.uid),
        builder: (BuildContext context, AsyncSnapshot<List<ClipModel>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return _EmptyState();
          }

          data = snapshot.data;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final ClipModel model = data[index];
              final ClipCard card = ClipCard(model: model);

              return widget.me
                ? Dismissible(
                    key: ValueKey<String>(model.uid),
                    direction: DismissDirection.endToStart,
                    child: card,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Icon(
                          MdiIcons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) async {
                      await bloc.remove(model);
                      setState(() {
                        data.removeAt(index);
                      });
                    },
                  )
                : card;
            },
          );
        },
      ),
      floatingActionButton: widget.me
        ? FloatingActionButton(
            child: const Icon(MdiIcons.plus),
            onPressed: () {
              // TODO(itsprof): validate if subscriber
              const bool subscriber = true;
              final int numberOfClips = data.length;

              final DialogHelper helper = DialogHelper.instance();

              if (subscriber) {
                if (numberOfClips < kSubClipLimit) {
                  Routes.router.navigateTo(context, 'clip/create/${widget.uid}');
                } else {
                  helper.showErrorDialog(
                    context: context,
                    title: 'Can\'t Add More Clips',
                    message: kSubClipLimitMessage,
                  );
                }
              } else {
                if (numberOfClips < kNoSubClipLimit) {
                  Routes.router.navigateTo(context, 'clip/create/${widget.uid}');
                } else {
                  helper.showSubscribeDialog(
                    context: context,
                    message: kNoSubClipLimitMessage,
                  );
                }
              }
            },
          )
        : null,
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
            MdiIcons.filmstrip,
            size: 80.0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Clips appear here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }
}
