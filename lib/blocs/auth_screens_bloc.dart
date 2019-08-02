import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/auth_screens_validator.dart';

/// BLoC containing logic to handle the sign in form.
class AuthScreensBloc extends BaseBloc with AuthScreensdValidator {
  final BehaviorSubject<String> _emailSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _confirmPasswordSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _usernameSubject = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailSubject
    .stream
    .transform(validateEmail);
  
  Stream<String> get passwordStream => _passwordSubject
    .stream
    .transform(validatePassword);

  Stream<String> get confirmPasswordStream => _confirmPasswordSubject
    .stream
    .transform(validatePassword)
    .doOnData((String data) {
      if (data.compareTo(passwordValue) != 0) {
        _confirmPasswordSubject.addError('Passwords don\'t match');
      }
    });
  
  Stream<String> get usernameStream => _usernameSubject
    .stream
    .transform(validateUsername);
  
  Stream<bool> get signInValidStream => Observable
    .combineLatest2(
      emailStream,
      passwordStream,
      (String e, String p) => true,
    );

  Stream<bool> get createAccountValidStream => Observable
    .combineLatest4(
      emailStream,
      passwordStream,
      confirmPasswordStream,
      usernameStream,
      (String e, String p, String cp, String u) => true,
    );

  String get emailValue => _emailSubject.value;
  String get passwordValue => _passwordSubject.value;
  String get usernameValue => _usernameSubject.value;

  void Function(String) get onChangeEmail => _emailSubject.sink.add;
  void Function(String) get onChangePassword => _passwordSubject.sink.add;
  void Function(String) get onChangeConfirmPassword => _confirmPasswordSubject.sink.add;
  void Function(String) get onChangeUsername => _usernameSubject.sink.add;
  
  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    _confirmPasswordSubject.close();
    _usernameSubject.close();
  }
}
