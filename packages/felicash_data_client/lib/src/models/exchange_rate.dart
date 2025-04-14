import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';

/// {@template exchange_rate_fields}
/// Exchange rate fields
/// {@endtemplate}
typedef ExchangeRateFields = _$ExchangeRateJsonKeys;

/// {@template exchange_rate_model}
/// Model for exchange rate.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class ExchangeRate {
  /// {@macro exchange_rate_model}
  const ExchangeRate({
    required this.exchangeRateId,
    required this.exchangeRateFromCurrency,
    required this.exchangeRateToCurrency,
    required this.exchangeRateRate,
    required this.exchangeRateEffectiveDate,
    required this.exchangeRateCreatedAt,
    required this.exchangeRateUpdatedAt,
  }) : id = exchangeRateId;

  /// Factory constructor for [ExchangeRate] from [SqliteRow]
  factory ExchangeRate.fromRow(SqliteRow row) {
    return ExchangeRate(
      exchangeRateId: row[ExchangeRateFields.exchangeRateId] as String,
      exchangeRateFromCurrency:
          row[ExchangeRateFields.exchangeRateFromCurrency] as String,
      exchangeRateToCurrency:
          row[ExchangeRateFields.exchangeRateToCurrency] as String,
      exchangeRateRate: row[ExchangeRateFields.exchangeRateRate] as double,
      exchangeRateEffectiveDate: DateTime.parse(
        row[ExchangeRateFields.exchangeRateEffectiveDate] as String,
      ),
      exchangeRateCreatedAt: DateTime.parse(
        row[ExchangeRateFields.exchangeRateCreatedAt] as String,
      ),
      exchangeRateUpdatedAt: DateTime.parse(
        row[ExchangeRateFields.exchangeRateUpdatedAt] as String,
      ),
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the exchange rate
  final String exchangeRateId;

  /// From currency of the exchange rate,
  /// e.g. USD
  final String exchangeRateFromCurrency;

  /// To currency of the exchange rate,
  /// e.g. EUR
  final String exchangeRateToCurrency;

  /// Rate of the exchange rate,
  /// e.g. 1.23
  final double exchangeRateRate;

  /// Effective date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime exchangeRateEffectiveDate;

  /// Created at date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime exchangeRateCreatedAt;

  /// Updated at date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime exchangeRateUpdatedAt;

  /// Returns a copy of the [ExchangeRate] with the given fields replaced.
  ExchangeRate copyWith({
    String? exchangeRateId,
    String? exchangeRateFromCurrency,
    String? exchangeRateToCurrency,
    double? exchangeRateRate,
    DateTime? exchangeRateEffectiveDate,
    DateTime? exchangeRateCreatedAt,
    DateTime? exchangeRateUpdatedAt,
  }) {
    return ExchangeRate(
      exchangeRateId: exchangeRateId ?? this.exchangeRateId,
      exchangeRateFromCurrency:
          exchangeRateFromCurrency ?? this.exchangeRateFromCurrency,
      exchangeRateToCurrency:
          exchangeRateToCurrency ?? this.exchangeRateToCurrency,
      exchangeRateRate: exchangeRateRate ?? this.exchangeRateRate,
      exchangeRateEffectiveDate:
          exchangeRateEffectiveDate ?? this.exchangeRateEffectiveDate,
      exchangeRateCreatedAt:
          exchangeRateCreatedAt ?? this.exchangeRateCreatedAt,
      exchangeRateUpdatedAt:
          exchangeRateUpdatedAt ?? this.exchangeRateUpdatedAt,
    );
  }
}
