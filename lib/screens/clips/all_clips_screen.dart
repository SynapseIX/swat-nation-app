import 'package:flutter/material.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';

/// Screen that lists all clips from a user.
class AllClipsScreen extends StatelessWidget {
  const AllClipsScreen({
    @required this.data,
    @required this.displayName,
    this.me = false
  });

  final List<ClipModel> data;
  final String displayName;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: me
          ? const Text('My Clips')
          : Text('$displayName\'s Clips'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final ClipModel model = data[index];
          return ClipCard(model: model);
        },
      ),
    );
  }
}
