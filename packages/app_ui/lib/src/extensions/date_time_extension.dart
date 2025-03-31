import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a yMMMEd with a given [locale].
  String yMMMEd([dynamic locale]) {
    return DateFormat.yMMMEd(locale).format(this);
  }
}
