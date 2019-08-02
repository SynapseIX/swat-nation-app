import 'dart:io'show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/auth_screens_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/dialogs/dialog_helper.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/screens/main_screen.dart';

/// Represents the create account screen.
class CreateAccountScreen extends StatefulWidget {
  @override
  State createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  AuthScreensBloc uiBloc;
  UserBloc userBloc;

  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode confirmPasswordNode;
  FocusNode usernameNode;

  @override
  void initState() {
    uiBloc = AuthScreensBloc();
    userBloc = UserBloc();

    emailNode = FocusNode();
    passwordNode = FocusNode();
    confirmPasswordNode = FocusNode();
    usernameNode = FocusNode();
    
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();

    uiBloc.dispose();
    userBloc.dispose();

    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    usernameNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: GestureDetector(
        onTap: () => _dismissKeyboard(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
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
                              fadeInDuration: Duration(milliseconds: 300),
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
                              onSubmitted: (String text) {
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
                              textInputAction: TextInputAction.next,
                              focusNode: passwordNode,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'password',
                                errorText: snapshot.error,
                              ),
                              onSubmitted: (String text) {
                                passwordNode.nextFocus();
                              },
                              onChanged: uiBloc.onChangePassword,
                            );
                          },
                        ),

                        // Confirm password field
                        StreamBuilder<String>(
                          stream: uiBloc.confirmPasswordStream,
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            return TextField(
                              controller: confirmPasswordController,
                              autocorrect: false,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              focusNode: confirmPasswordNode,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'confirm password',
                                errorText: snapshot.error,
                              ),
                              onSubmitted: (String text) {
                                confirmPasswordNode.nextFocus();
                              },
                              onChanged: uiBloc.onChangeConfirmPassword,
                            );
                          },
                        ),

                        // Username field
                        StreamBuilder<String>(
                          stream: uiBloc.displayNameStream,
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            return TextField(
                              controller: usernameController,
                              autocorrect: false,
                              textInputAction: TextInputAction.go,
                              focusNode: usernameNode,
                              maxLength: kUsernameMaxChararcters,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Username',
                                errorText: snapshot.error,
                              ),
                              onSubmitted: (String text) => _submitCreateAccount(context),
                              onChanged: uiBloc.onChangeDisplayName,
                            );
                          },
                        ),

                        const SizedBox(height: 24.0),

                        // Create Account button
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: StreamBuilder<bool>(
                            stream: uiBloc.createAccountValidStream,
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              return RaisedButton(
                                child: const Text('Create Account'),
                                onPressed: snapshot.hasData
                                  ? () => _submitCreateAccount(context)
                                  : null,
                              );
                            },
                          ),
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

  Future<void> _submitCreateAccount(BuildContext context) async {
    final DialogHelper helper = DialogHelper.instance();
    _dismissKeyboard();
    
    try {
      helper.showWaitingDialog(context, 'Creating your account...');

      final bool displayNameExists = await userBloc.displayNameExists(uiBloc.displayNameValue);
      if (displayNameExists) {
        Navigator.of(context).pop();
        return helper.showErrorDialog(
          context: context,
          title: 'Can\'t Create Account',
          message: 'Username itsprof is already taken!',
        );
      }

      final FirebaseUser user = await AuthBloc.instance().createAccount(
        email: uiBloc.emailValue,
        password: uiBloc.passwordValue,
      );

      final UserUpdateInfo info = UserUpdateInfo();
      info.displayName = uiBloc.displayNameValue;
      info.photoUrl = kDefaultAvi;

      await user.updateProfile(info);
      await user.reload();

      final UserModel model = UserModel(
        uid: user.uid,
        displayName: uiBloc.displayNameValue,
        photoUrl: kDefaultAvi,
        createdAt: Timestamp.now(), 
        platform: Platform.isIOS ? 'iOS' : 'Android',
      );
      await userBloc.createUser(model);

      Navigator.of(context)
        .pushAndRemoveUntil(
          MaterialPageRoute<MainScreen>(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> r) => false,
        );
    } catch (e) {
      Navigator.of(context).pop();
      helper.showErrorDialog(
        context: context,
        title: 'Can\'t Create Account',
        message: e.message,
      );
    }
    finally {
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      usernameController.clear();

      uiBloc.onChangeEmail('');
      uiBloc.onChangePassword('');
      uiBloc.onChangeConfirmPassword('');
      uiBloc.onChangeDisplayName('');
    }
  }

  void _dismissKeyboard() {
    if (emailNode.hasFocus) {
      emailNode.unfocus();
    }

    if (passwordNode.hasFocus) {
      passwordNode.unfocus();
    }

    if (confirmPasswordNode.hasFocus) {
      confirmPasswordNode.unfocus();
    }

    if (usernameNode.hasFocus) {
      usernameNode.unfocus();
    }
  }
}
