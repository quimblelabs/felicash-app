// ignore_for_file: prefer_const_constructors

import 'package:currency_repository/currency_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyRepository', () {
    test('can be instantiated', () {
      expect(CurrencyRepository(), isNotNull);
    });
  });
}
