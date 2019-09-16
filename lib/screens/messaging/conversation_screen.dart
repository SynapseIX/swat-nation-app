import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/// Represents the private messaging screen between the user and another user.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    Key key,
    @required this.recepientUid,
  }) : super(key: key);

  final String recepientUid;
  
  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        final String recepientUid = parameters['recepientUid'].first;
        return ConversationScreen(
          recepientUid: recepientUid,
        );
      }
    );
  }

  @override
  State createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
