import 'package:intl/intl.dart';

/// Extension to make displaying [double] objects simpler.
extension CurrencyEx on double {
  /// Converts a double into a currency string.
  String toCurrency({
    String? locale,
    String? name,
    String? symbol,
    int? decimalDigits,
  }) {
    return NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  /// Converts a double into a compact currency string.
  String toCompactCurrency({
    String? locale,
    String? name,
    String? symbol,
    int? decimalDigits,
  }) {
    return NumberFormat.compactCurrency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }
}
