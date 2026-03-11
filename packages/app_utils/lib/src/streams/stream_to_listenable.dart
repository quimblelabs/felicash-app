import 'dart:async';
import 'package:flutter/foundation.dart';

/// {@template stream_to_listenable}
/// Converts a list of streams to a listenable.
///
/// ```dart
/// final streams = [
///   Stream.value(1),
///   Stream.value(2),
/// ];
///
/// final listenable = StreamToListenable(streams);
///
/// listenable.addListener(() {
///   print(listenable.value);
/// });
/// ```
///
/// {@endtemplate}
class StreamToListenable<T> extends ChangeNotifier {
  /// {@macro stream_to_listenable}
  StreamToListenable(List<Stream<T>> streams) {
    subscriptions = streams.map((stream) {
      return stream.asBroadcastStream().listen((event) => notifyListeners());
    }).toList();
  }

  /// The value of the stream.
  late final List<StreamSubscription<T>> subscriptions;

  @override
  void dispose() {
    for (final sub in subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
