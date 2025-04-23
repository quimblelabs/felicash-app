import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:shared_models/shared_models.dart';

/// {@template get_currency_query}
/// Query for getting a currency.
/// {@endtemplate}
class GetCurrencyQuery extends BaseGetQuery {
  /// {@macro get_currency_query}
  const GetCurrencyQuery({
    this.code,
    this.name,
    this.symbol,
    super.pageIndex,
    super.pageSize,
    super.orderType,
    super.orderBy = CurrencyFields.currencyCreatedAt,
  });

  /// The code of the currency.
  final String? code;

  /// The name of the currency.
  final String? name;

  /// The symbol of the currency.
  final String? symbol;

  @override
  List<Object?> get props => [
        ...super.props,
        code,
        name,
        symbol,
      ];
}
