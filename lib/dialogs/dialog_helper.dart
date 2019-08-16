import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Creates dialogs needed for the application
class DialogHelper {
  factory DialogHelper.instance() => _instance;

  DialogHelper._internal();

  static final DialogHelper _instance = DialogHelper._internal();

  Future<Dialog> showWaitingDialog({
    @required BuildContext context,
    String title = 'Waiting...',
  }) {
    return showDialog<Dialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(height: 16.0),
                Text(title),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<Dialog> showErrorDialog({
      @required BuildContext context,
      String title = 'Error',
      String message = 'An unexpected error has ocurred.',
    }) {
    return showDialog<Dialog>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(32.0),
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
                  height: 30.0,
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
}