// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:token_storage/token_storage.dart';

class FakeTokenStorage extends Fake implements TokenStorage {}

void main() {
  group('TokenStorage', () {
    test('TokenStorage can be implemented', () {
      expect(FakeTokenStorage.new, returnsNormally);
    });
  });
}
