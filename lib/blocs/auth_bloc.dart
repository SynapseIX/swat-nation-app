import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
