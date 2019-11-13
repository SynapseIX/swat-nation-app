import 'dart:io' show Platform;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/achievements_bloc.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/auth_screens_bloc.dart';
import 'package:swat_nation/blocs/tab_bar_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/achievement_model.dart';
import 'package:swat_nation/models/badge_model.dart';
import 'package:swat_nation/models/navigation_result.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represents the sign in screen.
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key key,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        return const SignInScreen();
      }
    );
  }
  
  @override
  State createState() => _SignInScreenState();
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
        leading: IconButton(
          icon: const Icon(MdiIcons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => _dismissKeyboard(),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    // Logo
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: kLogo,
                        fadeInDuration: const Duration(milliseconds: 300),
                        width: 80.0,
                        height: 80.0,
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    Text(
                      'Sign in with email',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline,
                    ),

                    const SizedBox(height: 8.0),

                    // Email field
                    StreamBuilder<String>(
                      stream: uiBloc.emailStream,
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
                          onChanged: uiBloc.onChangeEmail,
                        );
                      },
                    ),

                    // Password field
                    StreamBuilder<String>(
                      stream: uiBloc.passwordStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          keyboardAppearance: ThemeBloc.instance().currentTheme is DarkTheme
                                ? Brightness.dark
                                : Brightness.light,
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
                          onSubmitted: (String value) {
                            _dismissKeyboard();

                            if (uiBloc.signInValidValue) {
                              _submitSignIn(context);
                            }
                          },
                          onChanged: uiBloc.onChangePassword,
                        );
                      },
                    ),

                    const SizedBox(height: 16.0),

                    // Sign In button
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: StreamBuilder<bool>(
                        stream: uiBloc.signInValidStream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          return RaisedButton(
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.green,
                            onPressed: snapshot.hasData
                              ? () => _submitSignIn(context)
                              : null,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Forgot Password
                    GestureDetector(
                      onTap: () async {
                        final NavigationResult result = await Routes
                          .router
                          .navigateTo(context, Routes.forgotPassword);

                        if (result != null) {
                          String message;
                          if (result.payload != null) {
                            message = result.payload;
                          }
                          if (result.error != null) {
                            message = result.error;
                          }

                          Scaffold.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text(message),
                          ));
                        }
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // OR Divider
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ),
                        Text(
                          '    or    ',
                          style: Theme.of(context).textTheme.headline,
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.body1.color,
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

                    const SizedBox(height: 24.0),

                    // OR Divider
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ),
                        Text(
                          '    New here?    ',
                          style: Theme.of(context).textTheme.headline,
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    // Create Account button
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: StreamBuilder<bool>(
                        stream: uiBloc.signInValidStream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          return RaisedButton(
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.lightBlue,
                            onPressed: () {
                              _dismissKeyboard();
                              Routes.router.navigateTo(context, Routes.createAccount);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
      
      final UserModel model = await userBloc.userByUid(user.uid);
      model.platform = Platform.isIOS ? 'iOS' : 'Android';
      await userBloc.update(model);

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.root,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
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

      TabBarBloc.instance().setCurrentIndex(0);
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

      final RegExp regExp = RegExp(r'\s+\b|\b\s|\s|\b');
      final String trimmedDisplayName = user.displayName.replaceAll(regExp, '');
      final int seed = DateTime.now().millisecondsSinceEpoch;
      final int random = Random(seed).nextInt(kFBPostFix);
      
      final String displayName =
            trimmedDisplayName.length > kDisplayNameMaxChararcters
            ? '${trimmedDisplayName.substring(0, kDisplayNameMaxChararcters - 5)}$random'
            : trimmedDisplayName;
      final UserUpdateInfo info = UserUpdateInfo();
      info.displayName = displayName;

      await user.updateProfile(info);
      await user.reload();
      
      final UserModel model = await userBloc.userByUid(user.uid) ?? UserModel(
        uid: user.uid,
        displayName: displayName,
        photoUrl: user.photoUrl,
        createdAt: Timestamp.now(),
        provider: UserProvider.facebook,
      );
      model.platform = platform;

      if (displayNameExists) {
        await userBloc.update(model);
      } else {
        await userBloc.create(model);
        await _unlockDefaultAchievement(model.uid);
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.root,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      helper.showErrorDialog(
        context: context,
        title: 'Can\'t Log In With Facebook',
        message: e is String 
          ? e
          : e.message ?? 'Unexpected error.',
      );
    } finally {
      TabBarBloc.instance().setCurrentIndex(0);
    }
  }

  Future<void> _unlockDefaultAchievement(String uid) async {
    final AchievementsBloc bloc = AchievementsBloc(uid: uid);
    final DocumentReference badge = Firestore
      .instance
      .collection('badges')
      .document(BadgeModel.becomeLegend);
    
    final AchievementModel achievement = AchievementModel(
      badge: badge,
      unlocked: Timestamp.now(),
    );
    
    await bloc.unlock(achievement);
    bloc.dispose();
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
