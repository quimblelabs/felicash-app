import 'package:formz/formz.dart';

/// Password Form Input Validation Error
enum PasswordValidationError {
  /// Password is empty
  empty,

  /// Password is too short
  tooShort,

  /// Password has no lowercase letter
  noLowercase,

  /// Password has no uppercase letter
  noUppercase,

  /// Password has no digit
  noDigit,

  /// Password has no symbol
  noSymbol
}

/// {@template password}
/// Reusable password form input.
/// Validates that the password:
/// - Has minimum length of 6 characters
/// - Contains at least one lowercase letter
/// - Contains at least one uppercase letter
/// - Contains at least one digit
/// - Contains at least one symbol
/// {@endtemplate}
class Password extends FormzInput<String, List<PasswordValidationError>> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  /// Checks if the password is empty
  bool _isEmpty(String value) => value.isEmpty || value.trim().isEmpty;

  /// Checks if the password meets minimum length requirement
  bool _isTooShort(String value) => value.length < 6;

  /// Checks if the password contains at least one lowercase letter
  bool _hasNoLowercase(String value) => !RegExp('[a-z]').hasMatch(value);

  /// Checks if the password contains at least one uppercase letter
  bool _hasNoUppercase(String value) => !RegExp('[A-Z]').hasMatch(value);

  /// Checks if the password contains at least one digit
  bool _hasNoDigit(String value) => !RegExp(r'\d').hasMatch(value);

  /// Checks if the password contains at least one special character
  bool _hasNoSymbol(String value) =>
      !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  @override
  List<PasswordValidationError>? validator(String value) {
    final errors = <PasswordValidationError>[];

    if (_isEmpty(value)) {
      errors.add(PasswordValidationError.empty);
      return errors;
    }

    if (_isTooShort(value)) errors.add(PasswordValidationError.tooShort);
    if (_hasNoLowercase(value)) errors.add(PasswordValidationError.noLowercase);
    if (_hasNoUppercase(value)) errors.add(PasswordValidationError.noUppercase);
    if (_hasNoDigit(value)) errors.add(PasswordValidationError.noDigit);
    if (_hasNoSymbol(value)) errors.add(PasswordValidationError.noSymbol);

    return errors.isEmpty ? null : errors;
  }
}
