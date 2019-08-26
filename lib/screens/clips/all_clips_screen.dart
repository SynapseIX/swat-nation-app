import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';

/// Screen that lists all clips from a user.
class AllClipsScreen extends StatefulWidget {
  const AllClipsScreen({
    Key key,
    @required this.data,
    @required this.displayName,
    this.me = false
  }) : super(key: key);

  final List<ClipModel> data;
  final String displayName;
  final bool me;

  static Handler routeHandler() {
    return Handler(
      type: HandlerType.route,

      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        final String displayName = parameters['displayName'].first;
        final bool me = parameters['me'].first == 'true';

        final ClipsBloc bloc = ClipsBloc();

        return StreamBuilder<List<ClipModel>>(
          stream: bloc.allClipsForUser(uid),
          initialData: const <ClipModel>[],
          builder: (BuildContext context, AsyncSnapshot<List<ClipModel>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            return AllClipsScreen(
              data: snapshot.data,
              displayName: displayName,
              me: me,
            );
          },
        );
      }
    );
  }

  @override
  State createState() => _AllClipsScreenState();
}

class _AllClipsScreenState extends State<AllClipsScreen> {
  ClipsBloc bloc;

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
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          final ClipModel model = widget.data[index];
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
                  widget.data.removeAt(index);
                  await bloc.remove(model);

                  if (widget.data.isEmpty) {
                    Navigator.pop(context);
                  }
                },
              )
            : card;
        },
      ),
    );
  }
}
