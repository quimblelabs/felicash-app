/// {@template date_extension}
/// Extension on [DateTime] to add some useful methods.
/// {@endtemplate}
extension DateExtension on DateTime {
  /// Returns the start of the month.
  DateTime startOfMonth() {
    return DateTime(
      year,
      month,
    );
  }

  /// Returns the end of the month.
  DateTime endOfMonth() {
    return DateTime(year, month + 1, 0).subtract(
      const Duration(seconds: 1),
    );
  }
}
