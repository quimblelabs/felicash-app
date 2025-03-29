import 'package:formz/formz.dart';

/// Wallet description input validation error.
enum WalletDescriptionValidationError {
  /// The input is too long.
  /// THemaximum length is 255.
  tooLong,
}

/// {@template wallet_description}
/// The input of the wallet's description.
/// {@endtemplate}
class WalletDescription
    extends FormzInput<String?, WalletDescriptionValidationError> {
  /// {@macro wallet_description}
  /// Mark the input as pure with an `null` value.
  const WalletDescription.pure() : super.pure(null);

  /// {@macro wallet_description}
  /// Mark the  input as dirty with the given [value].
  const WalletDescription.dirty([super.value]) : super.dirty();

  /// The maximum length of the input.
  int get maxLength => 255;

  @override
  WalletDescriptionValidationError? validator(String? value) {
    if (value != null && value.length > maxLength) {
      return WalletDescriptionValidationError.tooLong;
    }
    return null;
  }
}
