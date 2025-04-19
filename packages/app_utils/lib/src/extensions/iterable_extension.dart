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
    for (final element in this) {
      list
        ..add(element)
        ..add(separator);
    }
    return list;
  }
}
