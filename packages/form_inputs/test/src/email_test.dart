import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

void main() {
  group('Email', () {
    test('supports value equality', () {
      expect(
        const Email.pure(),
        equals(const Email.pure()),
      );
      expect(
        const Email.dirty('test@example.com'),
        equals(const Email.dirty('test@example.com')),
      );
    });

    group('constructors', () {
      test('pure creates correct instance', () {
        const email = Email.pure();
        expect(email.value, equals(''));
        expect(email.isPure, isTrue);
      });

      test('dirty creates correct instance', () {
        const email = Email.dirty('test@example.com');
        expect(email.value, equals('test@example.com'));
        expect(email.isPure, isFalse);
      });
    });

    group('validator', () {
      test('returns null for valid email addresses', () {
        expect(
          const Email.dirty('test@example.com').error,
          isNull,
        );
        expect(
          const Email.dirty('test.name@example.co.uk').error,
          isNull,
        );
        expect(
          const Email.dirty('test+label@example.com').error,
          isNull,
        );
      });

      test('returns error for empty email', () {
        expect(
          const Email.dirty().error,
          equals(EmailValidationError.empty),
        );
      });

      test('returns error for invalid email addresses', () {
        expect(
          const Email.dirty('test').error,
          equals(EmailValidationError.invalid),
        );
        expect(
          const Email.dirty('test@').error,
          equals(EmailValidationError.invalid),
        );
        expect(
          const Email.dirty('test@example').error,
          equals(EmailValidationError.invalid),
        );
        expect(
          const Email.dirty('@example.com').error,
          equals(EmailValidationError.invalid),
        );
      });
    });
  });
}
