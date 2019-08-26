import 'package:flutter/material.dart';

/// Input text widget for chat and comments.
class CommentInput extends StatelessWidget {
  const CommentInput({
    Key key,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onTap,
    this.hintText = 'Say something...',
    this.keyboardAppearance = Brightness.light,
    this.fillColor,
  }) : super(key: key);
  
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTap;
  final String hintText;
  final Brightness keyboardAppearance;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      height: 40.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardAppearance: keyboardAppearance,
        maxLength: 140,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 15.0, 10.0),
          counterText: '',
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
