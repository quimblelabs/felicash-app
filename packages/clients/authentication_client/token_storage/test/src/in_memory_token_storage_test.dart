import 'package:flutter_test/flutter_test.dart';
import 'package:token_storage/token_storage.dart';

void main() {
  group('InMemoryTokenStorage', () {
    late InMemoryTokenStorage storage;

    setUp(() {
      storage = InMemoryTokenStorage();
    });

    test('returns null when no token is stored', () async {
      final token = await storage.getToken();
      expect(token, isNull);
    });

    test('saves and retrieves token correctly', () async {
      const testToken = 'test-token';
      await storage.saveToken(testToken);
      final retrievedToken = await storage.getToken();
      expect(retrievedToken, equals(testToken));
    });

    test('clears token correctly', () async {
      const testToken = 'test-token';
      await storage.saveToken(testToken);
      await storage.clearToken();
      final retrievedToken = await storage.getToken();
      expect(retrievedToken, isNull);
    });

    test('updates existing token when saving new token', () async {
      const firstToken = 'first-token';
      const secondToken = 'second-token';

      await storage.saveToken(firstToken);
      await storage.saveToken(secondToken);

      final retrievedToken = await storage.getToken();
      expect(retrievedToken, equals(secondToken));
    });
  });
}
