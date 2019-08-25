import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/themes/dark_theme.dart';

/// Input text widget for chat and comments.
class CommentInput extends StatelessWidget {
  const CommentInput({
    Key key,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onTap,
    this.hintText = 'Say something...',
  }) : super(key: key);
  
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      height: 40.0,
      child: TextField(
        keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
          ? Brightness.dark
          : Brightness.light,
        controller: controller,
        focusNode: focusNode,
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
          fillColor: ThemeBloc.instance().currentTheme is DarkTheme
            ? const Color(0xFF333333)
            : Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 15.0, 10.0),
          counterText: '',
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
