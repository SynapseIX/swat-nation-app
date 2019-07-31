import 'dart:async';

import 'package:swat_nation/constants.dart';

/// Mixin for validating email addresses and passwords
class ValidatorMixin {
  final StreamTransformer<String, String> validateEmail = StreamTransformer<String, String>
    .fromHandlers(
      handleData: (String email, EventSink<String> sink) {
        final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
        
        if (emailRegExp.hasMatch(email)) {
          sink.add(email);
        } else {
          sink.addError('Enter a valid email address');
        }
      },
    );

  final StreamTransformer<String, String> validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, EventSink<String> sink) {
      final RegExp digitRegExp = RegExp(r'.*[0-9].*');

      if (password.length >= kPasswordMinLength) {
        if (digitRegExp.hasMatch(password)) {
          sink.add(password);
        } else {
          sink.addError('Password must have at least one number');  
        }
      } else {
        sink.addError('Password must be at least $kPasswordMinLength characters');
      }
    }
  );
}
