import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/src/password.dart';

void main() {
  group('Password', () {
    test('supports value equality', () {
      expect(
        const Password.pure(),
        equals(const Password.pure()),
      );
      expect(
        const Password.dirty('Password123!'),
        equals(const Password.dirty('Password123!')),
      );
    });

    group('constructors', () {
      test('pure creates correct instance', () {
        const password = Password.pure();
        expect(password.value, equals(''));
        expect(password.isPure, isTrue);
      });

      test('dirty creates correct instance', () {
        const password = Password.dirty('Password123!');
        expect(password.value, equals('Password123!'));
        expect(password.isPure, isFalse);
      });
    });

    group('validator', () {
      test('returns null for valid passwords', () {
        expect(
          const Password.dirty('Password123!').error,
          isNull,
        );
        expect(
          const Password.dirty('Abc123!@#').error,
          isNull,
        );
        expect(
          const Password.dirty('StrongP@ss1').error,
          isNull,
        );
      });

      test('returns empty error for empty password', () {
        expect(
          const Password.dirty().error,
          equals([PasswordValidationError.empty]),
        );
      });

      test('returns multiple errors for password without lowercase letters',
          () {
        expect(
          const Password.dirty('PASSWORD123!').error,
          containsAll([PasswordValidationError.noLowercase]),
        );
      });

      test('returns multiple errors for password without uppercase letters',
          () {
        expect(
          const Password.dirty('password123!').error,
          containsAll([PasswordValidationError.noUppercase]),
        );
      });

      test('returns multiple errors for password without digits', () {
        expect(
          const Password.dirty('Password!@#').error,
          containsAll([PasswordValidationError.noDigit]),
        );
      });

      test('returns multiple errors for password without symbols', () {
        expect(
          const Password.dirty('Password123').error,
          containsAll([PasswordValidationError.noSymbol]),
        );
      });

      test('returns multiple errors for password shorter than 6 characters',
          () {
        expect(
          const Password.dirty('Pa1!').error,
          containsAll([PasswordValidationError.tooShort]),
        );
      });

      test('returns multiple errors for invalid password', () {
        expect(
          const Password.dirty('a').error,
          containsAll([
            PasswordValidationError.tooShort,
            PasswordValidationError.noUppercase,
            PasswordValidationError.noDigit,
            PasswordValidationError.noSymbol,
          ]),
        );
      });
    });
  });
}
