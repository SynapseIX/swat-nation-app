import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/change_email_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/models/navigation_result.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              StreamBuilder<String>(
                stream: bloc.emailStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                          ? Brightness.dark
                          : Brightness.light,
                    controller: emailController,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    focusNode: emailNode,
                    decoration: InputDecoration(
                      labelText: 'New Email',
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
                stream: bloc.confirmEmailStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                          ? Brightness.dark
                          : Brightness.light,
                    controller: confirmEmailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    focusNode: confirmEmailNode,
                    decoration: InputDecoration(
                      labelText: 'Confirm Email',
                      hintText: 'user@example.com',
                      errorText: snapshot.error,
                    ),
                    onSubmitted: (String value) => _dismissKeyboard(),
                    onChanged: bloc.onChangeConfirmEmail,
                  );
                }
              ),

              const SizedBox(height:24.0),

              Container(
                width: double.infinity,
                height: 40.0,
                child: StreamBuilder<bool>(
                  stream: bloc.changeEmailValidStream,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return RaisedButton(
                      color: Colors.green,
                      child: const Text(
                        'Change Email',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: snapshot.hasData 
                        ? () async {
                          DialogHelper.instance().showWaitingDialog(
                            context: context,
                            title: 'Changing email...',
                          );

                          final PlatformException error = await AuthBloc
                            .instance()
                            .changeEmail(bloc.emailValue);
                          
                          final NavigationResult result = NavigationResult();
                          if (error == null) {
                            result.payload = 'Your email was successfully changed.';
                          } else {
                            result.error = error.message;
                          }
                          
                          Navigator.of(context)
                            ..pop()
                            ..pop(result);
                        }
                        : null,
                    );
                  }
                ),
              )
            ],
          ),
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
