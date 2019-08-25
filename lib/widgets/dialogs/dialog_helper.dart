import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/screens/auth/sign_in_screen.dart';

/// Creates dialogs needed for the application
class DialogHelper {
  factory DialogHelper.instance() => _instance;

  DialogHelper._internal();

  static final DialogHelper _instance = DialogHelper._internal();

  Future<void> showWaitingDialog({
    @required BuildContext context,
    String title = 'Working...',
  }) {
    return showDialog<Dialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future<bool>(() => false),
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16.0),
                  Text(title),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> showErrorDialog({
      @required BuildContext context,
      String title = 'Error',
      String message = 'An unexpected error has ocurred.',
    }) {
    return showDialog<Dialog>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  MdiIcons.alertOctagon,
                  size: 80.0,
                  color: Colors.red,
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(message),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Dismiss'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> showSubscribeDialog({
      @required BuildContext context,
      String message,
    }) {
    return showDialog<Dialog>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: kLogo,
                  fadeInDuration: const Duration(milliseconds: 300),
                  width: 100.0,
                  height: 100.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Become a SWAT Nation PRO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(message ?? kDefaultSubscribeMessage),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.grey,
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(height: 8.0),
                // TODO(itsprof): navigate to store screen
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.green,
                    child: const Text('Learn More'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSignInDIalog({
      @required BuildContext context,
    }) {
    return showDialog<Dialog>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: kLogo,
                  fadeInDuration: const Duration(milliseconds: 300),
                  width: 100.0,
                  height: 100.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Sign In / Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(kDefaultSignInMessage),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.grey,
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SignInScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                    },
                    color: Colors.green,
                    child: const Text('Let\'s do this!'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
