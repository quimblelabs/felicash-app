import 'package:formz/formz.dart';

/// The input is invalid format.
enum TransactionMonetaryAmountValidationError {
  /// The input is zero.
  zero,

  /// The input is under of the accepted range.
  under,

  /// The input is over of the accepted range.
  over,
}

/// {@template transaction_monetary_amount}
/// A form input for a transaction amount.
/// {@endtemplate}
class TransactionMonetaryAmount
    extends FormzInput<double, TransactionMonetaryAmountValidationError> {
  /// @macro transaction_monetary_amount
  ///
  /// Mark the input as pure.
  const TransactionMonetaryAmount.pure() : super.pure(0);

  /// @macro transaction_monetary_amount
  ///
  /// Mark the input as dirty with the given value.
  const TransactionMonetaryAmount.dirty([super.value = 0]) : super.dirty();

  /// The accepted range for the input.
  ({double min, double max}) get acceptedRange {
    return (
      min: -999999999999.0, // 12 zeros
      max: 999999999999.0, // 12 zeros
    );
  }

  @override
  TransactionMonetaryAmountValidationError? validator(double value) {
    if (value == 0) {
      return TransactionMonetaryAmountValidationError.zero;
    }

    if (value < acceptedRange.min) {
      return TransactionMonetaryAmountValidationError.under;
    }

    if (value > acceptedRange.max) {
      return TransactionMonetaryAmountValidationError.over;
    }

    return null;
  }
}
