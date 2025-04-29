import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

/// {@template currency_model}
/// Currency model for the app
/// {@endtemplate}
@JsonSerializable()
class CurrencyModel extends Equatable {
  /// {@macro currency_model}
  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
  });

  /// Factory constructor for [CurrencyModel] from JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  /// Factory constructor for [CurrencyModel] from [Currency]
  factory CurrencyModel.fromCurrency(Currency currency) {
    return CurrencyModel(
      code: currency.currencyCode,
      name: currency.currencyName,
      symbol: currency.currencySymbol,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  /// Code of the currency
  final String code;

  /// Name of the currency
  final String name;

  /// Symbol of the currency
  final String symbol;

  /// Empty currency model
  static const empty = CurrencyModel(code: '', name: '', symbol: '');

  ///  Check if the currency is empty
  bool get isEmpty => this == CurrencyModel.empty;

  @override
  List<Object?> get props => [code, name, symbol];
}
