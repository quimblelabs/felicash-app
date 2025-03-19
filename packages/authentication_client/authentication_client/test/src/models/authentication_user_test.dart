import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationUser', () {
    test('supports value equality', () {
      expect(
        const AuthenticationUser(id: 'test-id'),
        equals(const AuthenticationUser(id: 'test-id')),
      );
    });

    test('props contains all properties', () {
      const user = AuthenticationUser(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'Test User',
        isNewUser: true,
      );

      expect(
        user.props,
        equals([
          'test-id',
          'test@example.com',
          'Test User',
          true,
        ]),
      );
    });

    group('anonymous', () {
      test('returns user with empty id', () {
        expect(AuthenticationUser.anonymous.id, equals(''));
      });

      test('has null email', () {
        expect(AuthenticationUser.anonymous.email, isNull);
      });

      test('has null displayName', () {
        expect(AuthenticationUser.anonymous.displayName, isNull);
      });

      test('is not new user', () {
        expect(AuthenticationUser.anonymous.isNewUser, isFalse);
      });
    });

    group('isAnonymous', () {
      test('returns true for anonymous user', () {
        expect(AuthenticationUser.anonymous.isAnonymous, isTrue);
      });

      test('returns false for authenticated user', () {
        const user = AuthenticationUser(id: 'test-id');
        expect(user.isAnonymous, isFalse);
      });
    });

    test('creates user with all properties', () {
      const user = AuthenticationUser(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'Test User',
        isNewUser: true,
      );

      expect(user.id, equals('test-id'));
      expect(user.email, equals('test@example.com'));
      expect(user.displayName, equals('Test User'));
      expect(user.isNewUser, isTrue);
    });

    test('creates user with only required properties', () {
      const user = AuthenticationUser(id: 'test-id');

      expect(user.id, equals('test-id'));
      expect(user.email, isNull);
      expect(user.displayName, isNull);
      expect(user.isNewUser, isFalse);
    });
  });
}
