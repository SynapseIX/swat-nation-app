import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/auth_screens_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/screens/main_screen.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

import 'create_account_screen.dart';

/// Represents the sign in screen.
class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreensBloc uiBloc;
  UserBloc userBloc;

  FocusNode emailNode;
  FocusNode passwordNode;

  @override
  void initState() {
    uiBloc = AuthScreensBloc();
    userBloc = UserBloc();

    emailNode = FocusNode();
    passwordNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    uiBloc.dispose();
    userBloc.dispose();
    
    emailNode.dispose();
    passwordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: GestureDetector(
        onTap: () => _dismissKeyboard(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: <Widget>[
                    // Logo
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                      child: Hero(
                        tag: 'swat_nation_logo',
                        child: CachedNetworkImage(
                          imageUrl: kLogo,
                          fadeInDuration: const Duration(milliseconds: 300),
                          width: 120.0,
                          height: 120.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Email field
                    StreamBuilder<String>(
                      stream: uiBloc.emailStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
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
                          onChanged: uiBloc.onChangeEmail,
                        );
                      },
                    ),

                    // Password field
                    StreamBuilder<String>(
                      stream: uiBloc.passwordStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          controller: passwordController,
                          autocorrect: false,
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          focusNode: passwordNode,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'password',
                            errorText: snapshot.error,
                          ),
                          onSubmitted: (String value) => _submitSignIn(context),
                          onChanged: uiBloc.onChangePassword,
                        );
                      },
                    ),

                    const SizedBox(height: 24.0),

                    // Sign In button
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: StreamBuilder<bool>(
                        stream: uiBloc.signInValidStream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          return RaisedButton(
                            child: const Text('Sign In'),
                            onPressed: snapshot.hasData
                              ? () => _submitSignIn(context)
                              : null,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Create Account / Forgot Password
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _dismissKeyboard();
                            Navigator.of(context).push(
                              MaterialPageRoute<CreateAccountScreen>(
                                builder: (BuildContext context)=> CreateAccountScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => print('TODO: implement'),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    // Login with Facebook button
                    FlatButton(
                      child: Image.asset('assets/images/continue_with_facebook.png'),
                      onPressed: () => _loginWithFacebook(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitSignIn(BuildContext context) async {
    final DialogHelper helper = DialogHelper.instance();
    _dismissKeyboard();
    
    try {
      helper.showWaitingDialog(
        context: context,
        title: 'Signing In...',
      );

      final FirebaseUser user = await AuthBloc.instance().signIn(
        email: uiBloc.emailValue,
        password: uiBloc.passwordValue,
      );

      await userBloc.update(
        uid: user.uid,
        data: <String, dynamic>{
          'platform': Platform.isIOS ? 'iOS' : 'Android',
        },
      );

      Navigator.of(context)
        .pushAndRemoveUntil(
          MaterialPageRoute<MainScreen>(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> r) => false,
        );
    } catch (e) {
      Navigator.of(context).pop();
      helper.showErrorDialog(
        context: context,
        title: 'Can\'t Sign In',
        message: e.message,
      );
    }
    finally {
      emailController.clear();
      passwordController.clear();

      uiBloc.onChangeEmail('');
      uiBloc.onChangePassword('');
    }
  }

  Future<void> _loginWithFacebook(BuildContext context) async {
    final DialogHelper helper = DialogHelper.instance();
    _dismissKeyboard();

    try {
      helper.showWaitingDialog(
        context: context,
        title: 'Logging In With Facebook...',
      );

      final FirebaseUser user = await AuthBloc.instance().loginWithFacebook();
      final bool displayNameExists = await userBloc.displayNameExists(user.displayName);

      final String platform = Platform.isIOS ? 'iOS' : 'Android';
      
      final UserModel model = await userBloc.userByUid(user.uid) ?? UserModel(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        createdAt: Timestamp.now(),
        provider: UserProvider.facebook,
      );
      model.platform = platform;

      if (displayNameExists) {
        await userBloc.update(
          uid: user.uid,
          data: model.toMap(),
        );
      } else {
        await userBloc.create(model);
      }

      Navigator.of(context)
        .pushAndRemoveUntil(
          MaterialPageRoute<MainScreen>(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> r) => false,
        );
    } catch (e) {
      Navigator.of(context).pop();
      helper.showErrorDialog(
        context: context,
        title: 'Can\'t Log In With Facebook',
        message: e.message,
      );
    }
  }

  void _dismissKeyboard() {
    if (emailNode.hasFocus) {
      emailNode.unfocus();
    }

    if (passwordNode.hasFocus) {
      passwordNode.unfocus();
    }
  }
}
