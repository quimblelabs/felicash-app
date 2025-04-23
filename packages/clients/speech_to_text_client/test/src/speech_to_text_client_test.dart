// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_text_client/speech_to_text_client.dart';

void main() {
  group('SpeachToTextClient', () {
    test('can be instantiated', () {
      expect(SpeechToTextClient(), isNotNull);
    });

    test('can get available locales', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final client = SpeechToTextClient();
      final locales = await client.getSpeechLanguages();
      expect(locales, isNotEmpty);
    });
  });
}
