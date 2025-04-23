// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:permission_client/permission_client.dart';

void main() {
  group('PermissionClient', () {
    test('can be instantiated', () {
      expect(PermissionClient(), isNotNull);
    });
  });
}
