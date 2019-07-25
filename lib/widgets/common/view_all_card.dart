import 'package:flutter/material.dart';

/// View all widget to be used in lists of cards.
class ViewAllCard extends StatelessWidget {
  ViewAllCard({
    @required this.onTap,
    this.widthMultiplier = 0.3,
    this.heightMultiplier = 1.0,
    this.backgroundColor = Colors.white60,
  })  : assert(!heightMultiplier.isNegative && heightMultiplier <= 1.0),
        assert(!widthMultiplier.isNegative && widthMultiplier <= 1.0);

  final VoidCallback onTap;
  final double widthMultiplier;
  final double heightMultiplier;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * widthMultiplier,
        height: MediaQuery.of(context).size.height * heightMultiplier,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'view all',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
