import 'package:formz/formz.dart';

/// The validation error for the credit wallet state day of month.
enum WalletStateDayOfMonthValidationError {
  /// The input is out of range.
  outOfRange,
}

/// {@template credit_wallet_state_day_of_month}
/// A form input for a credit wallet state day of month.
/// {@endtemplate}
class WalletStateDayOfMonth
    extends FormzInput<int, WalletStateDayOfMonthValidationError> {
  /// @macro credit_wallet_state_day_of_month
  ///
  /// Mark the input as pure.
  const WalletStateDayOfMonth.pure() : super.pure(1);

  /// @macro credit_wallet_state_day_of_month
  ///
  /// Mark the input as dirty with the given value.
  const WalletStateDayOfMonth.dirty([super.value = 1]) : super.dirty();

  /// The accepted range for the input.
  ///
  /// From 1st to 28th day of the month.
  ({int min, int max}) get acceptedRange {
    return (
      min: 1,
      max: 28,
    );
  }

  @override
  WalletStateDayOfMonthValidationError? validator(int value) {
    if (value < acceptedRange.min || value > acceptedRange.max) {
      return WalletStateDayOfMonthValidationError.outOfRange;
    }
    return null;
  }
}
