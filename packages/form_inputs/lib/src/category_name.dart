import 'package:formz/formz.dart';

/// The validation error of the category name.
enum CategoryNameValidationError {
  /// The input is empty.
  empty,

  /// The input is too long.
  /// The maximum length is 50.
  tooLong,
}

/// {@template category_name}
/// The input of the category's name.
/// {@endtemplate}
class CategoryName extends FormzInput<String, CategoryNameValidationError> {
  /// {@macro category_name}
  const CategoryName.pure() : super.pure('');

  /// {@macro category_password}
  const CategoryName.dirty([super.value = '']) : super.dirty();

  /// The maximum length of the wallet name.
  int get maxLength => 50;

  @override
  CategoryNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return CategoryNameValidationError.empty;
    }

    if (value.length > maxLength) {
      return CategoryNameValidationError.tooLong;
    }

    return null;
  }
}
