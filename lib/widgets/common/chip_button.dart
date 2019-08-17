import 'package:flutter/material.dart';

// Creates a button based on a Material Chip.
class ChipButton extends StatelessWidget {
  const ChipButton({
    Key key,
    @required this.label,
    @required this.onTap,
    this.avatar
  }) : super(key: key);
  
  final Widget label;
  final Widget avatar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: label,
        avatar: avatar,
      ),
    );
  }
}
