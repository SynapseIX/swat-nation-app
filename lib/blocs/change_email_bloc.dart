import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/auth_screens_validator.dart';

/// BLoC containing logic to manage the change email screen.
class ChangeEmailBloc extends BaseBloc with AuthScreensdValidator {
  final BehaviorSubject<String> _emailSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _confirmEmailSubject = BehaviorSubject<String>();

  void Function(String) get onChangeEmail => _emailSubject.sink.add;
  void Function(String) get onChangeConfirmEmail => _emailSubject.sink.add;

  Stream<String> get emailStream => _emailSubject
    .stream
    .transform(validateEmail);
  
  Stream<String> get confirmEmailStream => _confirmEmailSubject
    .stream
    .transform(validateEmail)
    .doOnData((String data) {
      if (data.compareTo(emailValue) != 0) {
        _confirmEmailSubject.addError('Emails don\'t match');
      }
    });

  Stream<bool> get changeEmailValidStream => Observable
    .combineLatest2(
      emailStream,
      confirmEmailStream,
      (String e, String p) => true,
    );

  String get emailValue => _emailSubject.value;
  String get confirmEmailValue => _confirmEmailSubject.value;

  @override
  void dispose() {
    _emailSubject.close();
    _confirmEmailSubject.close();
    print('ChangeEmailBloc disposed');
  }
}
