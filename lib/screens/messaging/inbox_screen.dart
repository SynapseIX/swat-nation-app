import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/// Represents the user's inbox screen.
class InboxScreen extends StatefulWidget {
  const InboxScreen({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;
  
  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String uid = parameters['uid'].first;
        return InboxScreen(
          uid: uid,
        );
      }
    );
  }

  @override
  State createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
