import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a yMMMd with a given [locale].
  String yMMMd([dynamic locale]) {
    return DateFormat.yMMMd(locale).format(this);
  }

  /// Converts [DateTime] into a yMMMEd with a given [locale].
  String yMMMEd([dynamic locale]) {
    return DateFormat.yMMMEd(locale).format(this);
  }

  /// Converts [DateTime] into a yMMMEd with a given [locale].
  String yMMMMEEEEd([dynamic locale]) {
    return DateFormat.yMMMMEEEEd(locale).format(this);
  }

  /// Converts [DateTime] into a yMMM with a given [locale].
  String yMMM([dynamic locale]) {
    return DateFormat.yMMM(locale).format(this);
  }

  /// Whether the current [DateTime] is the same day as the given [other].
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
