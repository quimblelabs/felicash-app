import 'package:formz/formz.dart';

/// Category description input validation error.
enum CategoryDescriptionValidationError {
  /// The input is too long.
  /// THemaximum length is 255.
  tooLong,
}

/// {@template category_description}
/// The input of the category's description.
/// {@endtemplate}
class CategoryDescription
    extends FormzInput<String?, CategoryDescriptionValidationError> {
  /// {@macro category_description}
  /// Mark the input as pure with an `null` value.
  const CategoryDescription.pure() : super.pure(null);

  /// {@macro category_description}
  /// Mark the  input as dirty with the given [value].
  const CategoryDescription.dirty([super.value]) : super.dirty();

  /// The maximum length of the input.
  int get maxLength => 255;

  @override
  CategoryDescriptionValidationError? validator(String? value) {
    if (value != null && value.length > maxLength) {
      return CategoryDescriptionValidationError.tooLong;
    }
    return null;
  }
}
