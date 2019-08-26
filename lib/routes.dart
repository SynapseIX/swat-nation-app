import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/screens/auth/create_account_screen.dart';
import 'package:swat_nation/screens/auth/sign_in_screen.dart';
import 'package:swat_nation/screens/main_screen.dart';

/// Defines the navigation routes and application router.
class Routes {
  Routes._();

  static Router router;

  static String root = '/';
  
  static String signIn = '/sign-in';
  static String createAccount = '/create-account';
  
  static String profile = '/profile/:id';
  
  static String clip = '/clips/:id';
  static String clipAll = '/clips/all/:uid';
  static String clipCreate = '/clips/create';

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
  }
}
