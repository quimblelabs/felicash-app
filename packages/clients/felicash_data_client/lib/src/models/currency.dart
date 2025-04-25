import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

/// {@template currency_fields}
/// Currency fields
/// {@endtemplate}
typedef CurrencyFields = _$CurrencyJsonKeys;

/// {@template currency_model}
/// Currency model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Currency {
  /// {@macro currency_model}
  const Currency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.currencyCreatedAt,
    required this.currencyUpdatedAt,
  }) : id = currencyId;

  /// Factory constructor for [Currency] from [SqliteRow]
  factory Currency.fromRow(SqliteRow row) {
    return Currency(
      currencyId: row[CurrencyFields.currencyId] as String,
      currencyCode: row[CurrencyFields.currencyCode] as String,
      currencyName: row[CurrencyFields.currencyName] as String,
      currencySymbol: row[CurrencyFields.currencySymbol] as String,
      currencyCreatedAt: DateTime.parse(
        row[CurrencyFields.currencyCreatedAt] as String,
      ),
      currencyUpdatedAt: DateTime.parse(
        row[CurrencyFields.currencyUpdatedAt] as String,
      ),
    );
  }

  /// Table name of the currency
  static const String tableName = 'currencies';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the currency
  final String currencyId;

  /// Code of the currency
  final String currencyCode;

  /// Name of the currency
  final String currencyName;

  /// Symbol of the currency
  final String currencySymbol;

  /// Created at timestamp
  final DateTime currencyCreatedAt;

  /// Updated at timestamp
  final DateTime currencyUpdatedAt;

  /// Returns a copy of the [Currency] with the given fields replaced.
  Currency copyWith({
    String? currencyId,
    String? currencyCode,
    String? currencyName,
    String? currencySymbol,
    DateTime? currencyCreatedAt,
    DateTime? currencyUpdatedAt,
  }) {
    return Currency(
      currencyId: currencyId ?? this.currencyId,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyName: currencyName ?? this.currencyName,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCreatedAt: currencyCreatedAt ?? this.currencyCreatedAt,
      currencyUpdatedAt: currencyUpdatedAt ?? this.currencyUpdatedAt,
    );
  }
}
