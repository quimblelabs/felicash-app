/// An extension on [String] using on application UI.
extension StringExtension on String {
  /// A getter that returns the string as a hardcoded string.
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.hardCoded;
  /// ```
  ///
  /// Provides a way to find all hardcoded strings in the codebase.
  String get hardCoded => this;
}
