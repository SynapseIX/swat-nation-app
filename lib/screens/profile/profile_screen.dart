import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/models/user_model.dart';

/// Represents the user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    @required this.model,
  });
  
  final UserModel model;

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc.instance();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: authBloc.currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: snapshot.hasData && widget.model.uid == snapshot.data.uid
              ? const Text('My Profile')
              : const Text('Member Profile'),
            actions: <Widget>[
              if (snapshot.hasData && widget.model.uid == snapshot.data.uid)
              IconButton(
                icon: Icon(MdiIcons.accountEdit),
                onPressed: () {
                  print('TODO: navigate to edit profile screen');
                },
              ),
            ],
          ),
          body: Center(child: const Text('Under construction...')),
        );
      },
    );
  }
}
