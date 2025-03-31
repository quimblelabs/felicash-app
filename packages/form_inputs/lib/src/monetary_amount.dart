import 'package:formz/formz.dart';

/// The input is invalid format.
enum MonetaryAmountValidationError {
  /// The input is under of the accepted range.
  under,

  /// The input is over of the accepted range.
  over,
}

/// {@template monetary_amount}
/// A form input for a wallet balance.
/// {@endtemplate}
class MonetaryAmount extends FormzInput<double, MonetaryAmountValidationError> {
  /// @macro monetary_amount
  ///
  /// Mark the input as pure.
  const MonetaryAmount.pure() : super.pure(0);

  /// @macro monetary_amount
  ///
  /// Mark the input as dirty with the given value.
  const MonetaryAmount.dirty([super.value = 0]) : super.dirty();

  /// The accepted range for the input.
  ({double min, double max}) get acceptedRange {
    return (
      min: -999999999999.0, // 12 zeros
      max: 999999999999.0, // 12 zeros
    );
  }

  @override
  MonetaryAmountValidationError? validator(double value) {
    if (value < acceptedRange.min) {
      return MonetaryAmountValidationError.under;
    }

    if (value > acceptedRange.max) {
      return MonetaryAmountValidationError.over;
    }

    return null;
  }
}
