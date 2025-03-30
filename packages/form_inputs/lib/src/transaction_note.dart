import 'package:formz/formz.dart';

/// The validation error for the [TransactionNote].
enum TransactionNoteValidationError {
  /// The input is too long.
  ///
  /// See also [TransactionNote.maxLength].
  tooLong,
}

/// {@template wallet_description}
/// The input of the wallet's description.
/// {@endtemplate}
class TransactionNote
    extends FormzInput<String?, TransactionNoteValidationError> {
  /// {@macro wallet_description}
  /// Mark the input as pure with an `null` value.
  const TransactionNote.pure() : super.pure(null);

  /// {@macro wallet_description}
  /// Mark the  input as dirty with the given [value].
  const TransactionNote.dirty([super.value]) : super.dirty();

  /// The maximum length of the input.
  int get maxLength => 255;

  @override
  TransactionNoteValidationError? validator(String? value) {
    if (value != null && value.length > maxLength) {
      return TransactionNoteValidationError.tooLong;
    }
    return null;
  }
}
