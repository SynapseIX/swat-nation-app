import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/auth_screens_validator.dart';

// BLoC to validate data enter on the edit profile screen.
class EditProfileBloc extends BaseBloc with AuthScreensdValidator {
  final BehaviorSubject<String> _displayNameSubject = BehaviorSubject<String>();
  final BehaviorSubject<bool> _privacySubject = BehaviorSubject<bool>();

  Stream<String> get displayNameStream => _displayNameSubject
    .stream
    .transform(validateDisplayName);
  
  Stream<bool> get privacyStream => _privacySubject.stream;
  
  void Function(String) get onChangeDisplayName => _displayNameSubject.sink.add;
  void Function(bool) get onChangePrivacy => _privacySubject.sink.add;

  bool get privacyValue => _privacySubject.value;

  @override
  void dispose() {
    _displayNameSubject.close();
    _privacySubject.close();
  }
}
