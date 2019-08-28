import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/change_email_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/themes/dark_theme.dart';

/// Screen where users can change their account emails.
class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    Key key,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        return const ChangeEmailScreen();
      }
    );
  }

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode confirmEmailNode = FocusNode();

  ChangeEmailBloc bloc;

  @override
  void initState() {
    bloc = ChangeEmailBloc();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    confirmEmailController.dispose();

    emailNode.dispose();
    confirmEmailNode.dispose();

    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Email'),
        ),
        body: ListView(
          children: <Widget>[
            StreamBuilder<String>(
              stream: null,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return TextField(
                  keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                        ? Brightness.dark
                        : Brightness.light,
                  controller: emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: emailNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'user@example.com',
                    errorText: snapshot.error,
                  ),
                  onSubmitted: (String value) {
                    emailNode.nextFocus();
                  },
                  onChanged: bloc.onChangeEmail,
                );
              }
            ),

            StreamBuilder<String>(
              stream: null,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return TextField(
                  keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                        ? Brightness.dark
                        : Brightness.light,
                  controller: confirmEmailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: confirmEmailNode,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'user@example.com',
                    errorText: snapshot.error,
                  ),
                  onSubmitted: (String value) => _dismissKeyboard(),
                  onChanged: bloc.onChangeConfirmEmail,
                );
              }
            ),

            Container(
              width: double.infinity,
              height: 40.0,
              child: RaisedButton(
                color: Colors.green,
                child: const Text('Change Email'),
                onPressed: null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _dismissKeyboard() {
    if (emailNode.hasFocus) {
      emailNode.unfocus();
    }

    if (confirmEmailNode.hasFocus) {
      confirmEmailNode.unfocus();
    }
  }
}
