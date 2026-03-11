/// The extension adds a [mapIndexed] method to the [Iterable] class.
extension IterableExtension<T> on Iterable<T> {
  /// Maps each element to a new element using the given function and the index
  /// of the element.
  ///
  /// The [f] function takes two arguments: the index of the element and the
  /// element itself.
  ///
  /// The [f] function should return a value of type [R].
  ///
  /// The [mapIndexed] method returns an [Iterable] of type [R].
  ///
  /// Example:
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final newList = list.mapIndexed((index, element) => element * 2);
  /// print(newList); // [2, 4, 6]
  /// ```
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) sync* {
    var index = 0;
    for (final e in this) {
      yield f(index, e);
      index++;
    }
  }

  /// Join the elements of the iterable into a list of items.
  /// The [separator] is used to separate the items.
  Iterable<T> joinItems({
    required T separator,
  }) {
    final list = <T>[];
    for (var i = 0; i < length; i++) {
      list.add(elementAt(i));
      if (i < length - 1) {
        list.add(separator);
      }
    }
    return list;
  }

  /// Returns the first element that satisfies the given [test] function.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
