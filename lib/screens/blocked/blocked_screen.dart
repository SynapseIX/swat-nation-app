import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/// Represents the blocked users screen for the authenticated user.
class BlockedScreen extends StatefulWidget {
  const BlockedScreen({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        return BlockedScreen(
          uid: uid,
        );
      }
    );
  }

  @override
  State createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
