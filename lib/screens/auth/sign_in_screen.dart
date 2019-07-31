import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/constants.dart';

/// Represents the sign in landing screen.
class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FocusNode emailNode;
  FocusNode passwordNode;

  @override
  void initState() {
    emailNode = FocusNode();
    passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account / Sign In'),
      ),
      body: GestureDetector(
        onTap: () {
          if (emailNode.hasFocus) {
            emailNode.unfocus();
          }
          if (passwordNode.hasFocus) {
            passwordNode.unfocus();
          }
        },
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Container(
                    margin: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF333333),
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: kLogo,
                            fadeInDuration: Duration(milliseconds: 300),
                            width: 150.0,
                            height: 150.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text('If you already have an account, please Sign In. Otherwise, create a new account by tapping Create Account. You can also use Facebook to login.'),

                        // Text fields
                        _EmailField(
                          // TODO(itsprof): implement bloc
                          bloc: null,
                          focusNode: emailNode,
                        ),
                        _PasswordField(
                          bloc: null,
                          focusNode: passwordNode,
                        ),

                        const SizedBox(height: 24.0),

                        // Sign In button

                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: RaisedButton(
                            child: const Text('Sign In'),
                            onPressed: () => print('TODO: use bloc'),
                          ),
                        ),

                        // Create Account / Forgot Password

                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Create Account'),
                              onPressed: () => print('TODO: implement'),
                            ),
                            const Spacer(),
                            FlatButton(
                              child: const Text('Forgot password?'),
                              onPressed: () => print('TODO: implement'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32.0),

                        // Login with Facebook button

                        FlatButton(
                          child: Image.asset('assets/images/continue_with_facebook.png'),
                          onPressed: () => print('TODO: implement'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    @required this.bloc,
    @required this.focusNode,
  });
  
  final BaseBloc bloc;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String text) => print('TODO: use bloc'),
      keyboardType: TextInputType.emailAddress,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@example.com',
        // errorText: 'TODO: use bloc',
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    @required this.bloc,
    @required this.focusNode,
  });
  
  final BaseBloc bloc;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String text) => print('TODO: use bloc'),
      autocorrect: false,
      obscureText: true,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'password',
        // errorText: 'TODO: use bloc',
      ),
    );
  }
}
