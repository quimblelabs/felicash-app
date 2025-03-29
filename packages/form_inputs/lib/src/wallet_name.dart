import 'package:formz/formz.dart';

/// The validation error of the wallet name.
enum WalletNameValidationError {
  /// The input is empty.
  empty,

  /// The input is too long.
  /// The maximum length is 50.
  tooLong,
}

/// {@template wallet_name}
/// The input of the wallet's name.
/// {@endtemplate}
class WalletName extends FormzInput<String, WalletNameValidationError> {
  /// {@macro wallet_name}
  const WalletName.pure() : super.pure('');

  /// {@macro simple_password}
  const WalletName.dirty([super.value = '']) : super.dirty();

  /// The maximum length of the wallet name.
  int get maxLength => 50;

  @override
  WalletNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return WalletNameValidationError.empty;
    }

    if (value.length > maxLength) {
      return WalletNameValidationError.tooLong;
    }

    return null;
  }
}
