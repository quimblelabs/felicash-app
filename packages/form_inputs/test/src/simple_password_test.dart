import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/src/simple_password.dart';

void main() {
  group('SimplePassword', () {
    test('supports value equality', () {
      expect(
        const SimplePassword.pure(),
        equals(const SimplePassword.pure()),
      );
      expect(
        const SimplePassword.dirty('password'),
        equals(const SimplePassword.dirty('password')),
      );
    });

    group('constructors', () {
      test('pure creates correct instance', () {
        const password = SimplePassword.pure();
        expect(password.value, equals(''));
        expect(password.isPure, isTrue);
      });

      test('dirty creates correct instance', () {
        const password = SimplePassword.dirty('password');
        expect(password.value, equals('password'));
        expect(password.isPure, isFalse);
      });
    });

    group('validator', () {
      test('returns empty error when empty', () {
        expect(
          const SimplePassword.dirty().error,
          equals(SimplePasswordValidationError.empty),
        );
        expect(
          const SimplePassword.dirty(' ').error,
          equals(SimplePasswordValidationError.empty),
        );
      });

      test('returns null when not empty', () {
        expect(
          const SimplePassword.dirty('password').error,
          isNull,
        );
      });
    });
  });
}
