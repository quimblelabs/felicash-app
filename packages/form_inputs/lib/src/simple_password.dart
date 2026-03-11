import 'package:formz/formz.dart';

/// Simple Password Form Input Validation Error
enum SimplePasswordValidationError {
  /// Password is empty
  empty
}

/// {@template simple_password}
/// Reusable simple password form input.
/// Only validates that the password is not empty.
/// {@endtemplate}
class SimplePassword extends FormzInput<String, SimplePasswordValidationError> {
  /// {@macro simple_password}
  const SimplePassword.pure() : super.pure('');

  /// {@macro simple_password}
  const SimplePassword.dirty([super.value = '']) : super.dirty();

  @override
  SimplePasswordValidationError? validator(String value) {
    return value.isEmpty || value.trim().isEmpty
        ? SimplePasswordValidationError.empty
        : null;
  }
}
