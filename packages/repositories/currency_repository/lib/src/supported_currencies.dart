import 'package:currency_repository/src/models/currency_model.dart';

/// A class that contains the supported currencies
abstract class SupportedCurrencies {
  /// The available currencies that can be used in the app
  static Set<CurrencyModel> get availableCurrencies {
    return {usd, vnd, eur};
  }

  /// The USD currency
  static const usd = CurrencyModel(
    code: 'USD',
    name: 'United States Dollar',
    symbol: r'$',
  );

  /// The VND currency
  static const vnd = CurrencyModel(
    code: 'VND',
    name: 'Vietnamese Dong',
    symbol: '₫',
  );

  /// The EUR currency
  static const eur = CurrencyModel(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
  );
}
