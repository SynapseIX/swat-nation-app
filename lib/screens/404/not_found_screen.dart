import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Represents the screen to show when navigating to an unknown route.
class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            MdiIcons.emoticonDeadOutline,
            size: 80.0,
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Ooops! Nothing to see here.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
          const SizedBox(height: 24.0),
          FlatButton(
            child: const Text('Go Back'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      ),
    );
  }
}
