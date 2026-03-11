import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreamToListenable', () {
    test('notifies listeners when stream emits', () {
      final controller = StreamController<int>();
      final listenable = StreamToListenable([controller.stream]);
      var notificationCount = 0;

      listenable.addListener(() {
        notificationCount++;
      });

      controller.add(1);
      expect(notificationCount, 1);

      controller.add(2);
      expect(notificationCount, 2);

      controller.close();
      listenable.dispose();
    });

    test('handles multiple streams', () {
      final controller1 = StreamController<int>();
      final controller2 = StreamController<int>();
      final listenable =
          StreamToListenable([controller1.stream, controller2.stream]);
      var notificationCount = 0;

      listenable.addListener(() {
        notificationCount++;
      });

      controller1.add(1);
      expect(notificationCount, 1);

      controller2.add(1);
      expect(notificationCount, 2);

      controller1.close();
      controller2.close();
      listenable.dispose();
    });

    test('cancels subscriptions on dispose', () {
      final controller = StreamController<int>();
      final listenable = StreamToListenable([controller.stream]);
      var notificationCount = 0;

      listenable.addListener(() {
        notificationCount++;
      });

      controller.add(1);
      expect(notificationCount, 1);

      listenable.dispose();
      controller.add(2);
      expect(notificationCount, 1);

      controller.close();
    });

    test('works with broadcast streams', () {
      final controller = StreamController<int>.broadcast();
      final listenable = StreamToListenable([controller.stream]);
      var notificationCount = 0;

      listenable.addListener(() {
        notificationCount++;
      });

      controller.add(1);
      expect(notificationCount, 1);

      controller.close();
      listenable.dispose();
    });
  });
}
