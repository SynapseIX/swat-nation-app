import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/validator_mixin.dart';

/// BLoC containing logic to handle the sign in form.
class SignInScreenBloc extends BaseBloc with ValidatorMixin {
  final BehaviorSubject<String> _emailSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailSubject.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordSubject.stream.transform(validatePassword);
  Stream<bool> get submitValidStream => Observable
    .combineLatest2(emailStream, passwordStream, (String e, String p) => true);

  String get emailValue => _emailSubject.value;
  String get passwordValue => _passwordSubject.value; 

  void Function(String) get onChangeEmail => _emailSubject.sink.add;
  void Function(String) get onChangePassword => _passwordSubject.sink.add;
  
  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
  }
}
