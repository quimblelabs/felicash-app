import 'package:formz/formz.dart';

/// The input is invalid format.
enum WalletMonetarySavingsGoalValidationError {
  /// The input is zero.
  zero,

  /// The input is under of the accepted range.
  under,

  /// The input is over of the accepted range.
  over,
}

/// {@template monetary_amount}
/// A form input for a wallet balance.
/// {@endtemplate}
class WalletMonetarySavingsGoal
    extends FormzInput<double, WalletMonetarySavingsGoalValidationError> {
  /// @macro wallet_monetary_savings_goal
  ///
  /// Mark the input as pure.
  const WalletMonetarySavingsGoal.pure() : super.pure(0);

  /// @macro monetary_amount
  ///
  /// Mark the input as dirty with the given value.
  const WalletMonetarySavingsGoal.dirty([super.value = 0]) : super.dirty();

  /// The accepted range for the input.
  ({double min, double max}) get acceptedRange {
    return (
      min: -999999999999.0, // 12 zeros
      max: 999999999999.0, // 12 zeros
    );
  }

  @override
  WalletMonetarySavingsGoalValidationError? validator(double value) {
    if (value == 0) {
      return WalletMonetarySavingsGoalValidationError.zero;
    }

    if (value < acceptedRange.min) {
      return WalletMonetarySavingsGoalValidationError.under;
    }

    if (value > acceptedRange.max) {
      return WalletMonetarySavingsGoalValidationError.over;
    }

    return null;
  }
}
