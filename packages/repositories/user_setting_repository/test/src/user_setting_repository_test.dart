// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:user_setting_repository/user_setting_repository.dart';

void main() {
  group('UserSettingRepository', () {
    test('can be instantiated', () {
      expect(UserSettingRepository(), isNotNull);
    });
  });
}
