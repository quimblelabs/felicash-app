import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';

/// {@template currency_model}
/// Currency model for the app
/// {@endtemplate}
class CurrencyModel extends Equatable {
  /// {@macro currency_model}
  const CurrencyModel({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor for [CurrencyModel] from [Currency]
  factory CurrencyModel.fromCurrency(Currency currency) {
    return CurrencyModel(
      id: currency.id,
      code: currency.currencyCode,
      name: currency.currencyName,
      symbol: currency.currencySymbol,
      createdAt: currency.currencyCreatedAt,
      updatedAt: currency.currencyUpdatedAt,
    );
  }

  /// Id of the currency
  final String id;

  /// Code of the currency
  final String code;

  /// Name of the currency
  final String name;

  /// Symbol of the currency
  final String symbol;

  /// Date of creation of the currency
  final DateTime createdAt;

  /// Date of update of the currency
  final DateTime updatedAt;

  /// Empty currency model
  static final empty = CurrencyModel(
    id: '',
    code: '',
    name: '',
    symbol: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  ///  Check if the currency is empty
  bool get isEmpty => this == CurrencyModel.empty;

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        symbol,
        createdAt,
        updatedAt,
      ];
}
