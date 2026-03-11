import 'package:formz/formz.dart';

/// The input is invalid format.
enum WalletMonetaryBalanceValidationError {
  /// The input is under of the accepted range.
  under,

  /// The input is over of the accepted range.
  over,
}

/// {@template monetary_amount}
/// A form input for a wallet balance.
/// {@endtemplate}
class WalletMonetaryBalance
    extends FormzInput<double, WalletMonetaryBalanceValidationError> {
  /// @macro wallet_monetary_balance
  ///
  /// Mark the input as pure.
  const WalletMonetaryBalance.pure() : super.pure(0);

  /// @macro monetary_amount
  ///
  /// Mark the input as dirty with the given value.
  const WalletMonetaryBalance.dirty([super.value = 0]) : super.dirty();

  /// The accepted range for the input.
  ({double min, double max}) get acceptedRange {
    return (
      min: -999999999999.0, // 12 zeros
      max: 999999999999.0, // 12 zeros
    );
  }

  @override
  WalletMonetaryBalanceValidationError? validator(double value) {
    if (value < acceptedRange.min) {
      return WalletMonetaryBalanceValidationError.under;
    }

    if (value > acceptedRange.max) {
      return WalletMonetaryBalanceValidationError.over;
    }

    return null;
  }
}
