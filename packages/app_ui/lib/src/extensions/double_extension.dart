import 'package:intl/intl.dart';

/// Extension to make displaying [double] objects simpler.
extension CurrencyEx on double {
  /// Calculates the number of decimal digits in a double.
  int calculateDecimalDigits({
    int maxDigits = 3,
  }) {
    final decimal = toString().split('.')[1];
    if (decimal == '0') {
      return 0;
    }
    return decimal.length > maxDigits ? maxDigits : decimal.length;
  }

  /// Converts a double into a currency string.
  ///
  /// - [locale] - The locale to use for the currency.
  /// - [name] - The name of the currency.
  /// - [symbol] - The symbol of the currency.
  /// - [decimalDigits] - The number of decimal digits to display.
  /// If not specified, the number of decimal digits will be calculated by
  /// using [calculateDecimalDigits].
  String toCurrency({
    String? locale,
    String? name,
    String? symbol,
    int? decimalDigits,
  }) {
    final digits = decimalDigits ?? calculateDecimalDigits();
    return NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: digits,
    ).format(this);
  }

  /// Converts a double into a compact currency string.
  ///
  /// - [locale] - The locale to use for the currency.
  /// - [name] - The name of the currency.
  /// - [symbol] - The symbol of the currency.
  /// - [decimalDigits] - The number of decimal digits to display.
  /// If not specified, the number of decimal digits will be calculated by
  /// using [calculateDecimalDigits].
  String toCompactCurrency({
    String? locale,
    String? name,
    String? symbol,
    int? decimalDigits,
  }) {
    final digits = decimalDigits ?? calculateDecimalDigits();
    return NumberFormat.compactCurrency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: digits,
    ).format(this);
  }
}
