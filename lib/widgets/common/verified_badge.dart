import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/constants.dart';

/// Represents a verified badge with a white checkbox inside a decagram.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    this.size = 20.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(kVerifiedCopy),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: size / 2.0,
            height: size / 2.0,
            color: Colors.white,
          ),
          Icon(
            MdiIcons.checkDecagram,
            color: Colors.lightBlue,
            size: size,
          ),
        ],
      ),
    );
  }
}
