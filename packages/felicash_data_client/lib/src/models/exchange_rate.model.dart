import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// {@template exchange_rate_model}
/// Model for exchange rate.
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'exchange_rates'),
)
// ignore: must_be_immutable
class ExchangeRate extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro exchange_rate_model}
  ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.effectiveDate,
    required this.createdAt,
    required this.updatedAt,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the exchange rate
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// From currency of the exchange rate,
  /// e.g. USD
  final String fromCurrency;

  /// To currency of the exchange rate,
  /// e.g. EUR
  final String toCurrency;

  /// Rate of the exchange rate,
  /// e.g. 1.23
  final double rate;

  /// Effective date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime effectiveDate;

  /// Created at date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime createdAt;

  /// Updated at date of the exchange rate,
  /// e.g. 2021-01-01
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    fromCurrency,
    toCurrency,
    rate,
    effectiveDate,
    createdAt,
    updatedAt,
  ];
}
