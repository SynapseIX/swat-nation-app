import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';

/// Screen that lists all clips from a user.
class AllClipsScreen extends StatefulWidget {
  const AllClipsScreen({
    @required this.data,
    @required this.displayName,
    this.me = false
  });

  final List<ClipModel> data;
  final String displayName;
  final bool me;

  @override
  State createState() => _AllClipsScreenState();
}

class _AllClipsScreenState extends State<AllClipsScreen> {
  ClipsBloc bloc;
  List<ClipModel> data;

  @override
  void initState() {
    bloc = ClipsBloc();
    data = widget.data;
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
                  setState(() {
                    data.removeAt(index);
                  });
                  await bloc.remove(model);

                  if (data.isEmpty) {
                    Navigator.of(context).pop();
                  }
                },
              )
            : card;
        },
      ),
    );
  }
}
