import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';

/// {@template currency_model}
/// Currency model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'currencies'),
)
// ignore: must_be_immutable
class Currency extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro currency_model}
  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Code of the currency
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String code;

  /// Name of the currency
  final String name;

  /// Symbol of the currency
  final String symbol;

  /// Created at timestamp
  final DateTime createdAt;

  /// Updated at timestamp
  final DateTime updatedAt;

  @override
  List<Object?> get props => [code, name, symbol, createdAt, updatedAt];
}
