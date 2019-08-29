import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/auth_screens_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/navigation_result.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Screen where users can change their account emails.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key key,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        return const ForgotPasswordScreen();
      }
    );
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();

  AuthScreensBloc bloc;

  @override
  void initState() {
    bloc = AuthScreensBloc();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailNode.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<String>(
            stream: bloc.emailStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return ListView(
                children: <Widget>[
                  TextField(
                    keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                          ? Brightness.dark
                          : Brightness.light,
                    controller: emailController,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    focusNode: emailNode,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'user@example.com',
                      errorText: snapshot.error,
                    ),
                    onSubmitted: (String value) {
                      _dismissKeyboard();

                      if (snapshot.hasData) {
                        _submit();
                      }
                    },
                    onChanged: bloc.onChangeEmail,
                  ),

                  const SizedBox(height: 16.0),
                  const Text(kEmailAddressForPasswordReset),

                  const SizedBox(height:24.0),

                  Container(
                    width: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                      color: Colors.green,
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: snapshot.hasData 
                        ? _submit
                        : null,
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    DialogHelper.instance().showWaitingDialog(
      context: context,
      title: 'Requesting password email...',
    );

    final PlatformException error = await AuthBloc
      .instance()
      .requestPasswordReset(bloc.emailValue);
    
    final NavigationResult result = NavigationResult();
    if (error == null) {
      result.payload = kResetPasswordRequestSent;
    } else {
      result.error = error.message;
    }
    
    Navigator.of(context)
      ..pop()
      ..pop(result);
  }

  void _dismissKeyboard() {
    if (emailNode.hasFocus) {
      emailNode.unfocus();
    }
  }
}
