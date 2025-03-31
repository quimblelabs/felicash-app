import 'package:formz/formz.dart';

/// The validation error of the wallet credit limit.
enum WalletCreditLimitValidationError {
  /// The input is over the credit limit maximum value.
  over,

  /// The input is under the credit limit minimum value.
  under,

  /// Can not be zero.
  canNotBeZero,
}

/// {@template wallet_credit_limit}
/// A form input for a wallet credit limit.
/// {@endtemplate}
class WalletCreditLimit
    extends FormzInput<double, WalletCreditLimitValidationError> {
  /// @macro wallet_credit_limit
  ///
  /// Mark the input as pure.
  const WalletCreditLimit.pure() : super.pure(0);

  /// @macro wallet_credit_limit
  ///
  /// Mark the input as dirty with the given value.
  const WalletCreditLimit.dirty([super.value = 0.0]) : super.dirty();

  /// The accepted range for the input.
  ({double min, double max}) get acceptedRange {
    return (
      min: 0.0,
      max: 1000000000.0,
    );
  }

  @override
  WalletCreditLimitValidationError? validator(double value) {
    if (value > acceptedRange.max) {
      return WalletCreditLimitValidationError.over;
    }
    if (value < acceptedRange.min) {
      return WalletCreditLimitValidationError.under;
    }
    if (value == 0) {
      return WalletCreditLimitValidationError.canNotBeZero;
    }
    return null;
  }
}
