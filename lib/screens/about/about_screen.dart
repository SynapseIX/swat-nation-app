import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

/// Represents the about us screen.
class AboutScreen extends StatelessWidget {
  const AboutScreen({
    Key key,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        return const AboutScreen();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
