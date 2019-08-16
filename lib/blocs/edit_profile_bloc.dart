import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/auth_screens_validator.dart';

// BLoC to validate data enter on the edit profile screen.
class EditProfileBloc extends BaseBloc with AuthScreensdValidator {
  final BehaviorSubject<String> _displayNameSubject = BehaviorSubject<String>();

  Stream<String> get displayNameStream => _displayNameSubject
    .stream
    .transform(validateDisplayName);
  
  void Function(String) get onChangeDisplayName => _displayNameSubject.sink.add;

  @override
  void dispose() {
    _displayNameSubject.close();
  }
}
