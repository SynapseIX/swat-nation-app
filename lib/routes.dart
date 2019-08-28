import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/screens/achievements/achievements_screen.dart';
import 'package:swat_nation/screens/auth/create_account_screen.dart';
import 'package:swat_nation/screens/auth/forgot_password_screen.dart';
import 'package:swat_nation/screens/auth/sign_in_screen.dart';
import 'package:swat_nation/screens/clips/all_clips_screen.dart';
import 'package:swat_nation/screens/clips/clip_screen.dart';
import 'package:swat_nation/screens/clips/create_clip_screen.dart';
import 'package:swat_nation/screens/main_screen.dart';
import 'package:swat_nation/screens/profile/change_email_screen.dart';
import 'package:swat_nation/screens/profile/edit_profile_screen.dart';
import 'package:swat_nation/screens/profile/profile_screen.dart';

/// Defines the navigation routes and application router.
class Routes {
  Routes._();

  static Router router;

  static String root = '/';
  
  static String signIn = '/sign-in';
  static String createAccount = '/create-account';
  static String forgotPassword = '/forgot-password';
  
  static String profile = '/profile/:uid';
  static String editProfile = '/profile/edit/:uid';
  static String changeEmail = '/profile/change-email/';

  static String achievements = '/achievements/:uid/:me';
  
  static String clip = '/clip/:uid';
  static String clipAll = '/clip/all/:uid/:displayName/:me';
  static String clipCreate = '/clip/create/:uid';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        // TODO(itsprof): create Not Found screen
        return null;
      },
    );

    // Root route
    router.define(root, handler: MainScreen.routeHandler());

    // Sign In / Create Account
    router.define(
      signIn,
      handler: SignInScreen.routeHandler(),
      transitionType: TransitionType.inFromBottom,
    );
    router.define(
      createAccount,
      handler: CreateAccountScreen.routeHandler(),
      transitionType: TransitionType.native,
    );
    router.define(
      forgotPassword,
      handler: ForgotPasswordScreen.routeHandler(),
      transitionType: TransitionType.native,
    );

    // Profiles
    router.define(
      profile,
      handler: ProfileScreen.routeHandler(),
      transitionType: TransitionType.inFromBottom,
    );
    router.define(
      editProfile,
      handler: EditProfileScreen.routeHandler(),
      transitionType: TransitionType.native,
    );
    router.define(
      changeEmail,
      handler: ChangeEmailScreen.routeHandler(),
      transitionType: TransitionType.native,
    );

    // Achievements
    router.define(
      achievements,
      handler: AchievementsScreen.routeHandler(),
      transitionType: TransitionType.native,
    );

    // Clips
    router.define(
      clip,
      handler: ClipScreen.routeHandler(),
      transitionType: TransitionType.inFromBottom,
    );
    router.define(
      clipAll,
      handler: AllClipsScreen.routeHandler(),
      transitionType: TransitionType.native,
    );
    router.define(
      clipCreate,
      handler: CreateClipScreen.routeHandler(),
      transitionType: TransitionType.native,
    );
  }
}
