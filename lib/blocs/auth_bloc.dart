import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:swat_nation/base/base_bloc.dart';

/// Authentication management BLoC.
class AuthBloc extends BaseBloc {
  factory AuthBloc.instance() => _bloc;

  AuthBloc._internal();

  static final AuthBloc _bloc = AuthBloc._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged;
  Future<FirebaseUser> get currentUser => _firebaseAuth.currentUser();

  Future<FirebaseUser> signIn({
    @required String email,
    @required String password,
  }) async {
    final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future<FirebaseUser> loginWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult fbLoginResult = await facebookLogin
      .logInWithReadPermissions(<String>['public_profile', 'email']);

    switch (fbLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = fbLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider
          .getCredential(accessToken: accessToken.token);
        final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);

        return authResult.user;
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw 'Login cancelled by user.';
        break;
      case FacebookLoginStatus.error:
        throw fbLoginResult.errorMessage;
        break;
      default:
          return null;
          break;
      }
  }

  Future<FirebaseUser> createAccount({
    @required String email,
    @required String password,
  }) async {
    final AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {
    print('Auth BLoC disposed');
  }
}
