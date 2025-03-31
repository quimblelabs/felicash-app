import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/transaction.model.dart';
import 'package:uuid/uuid.dart';

/// {@template savings_wallet_model}
/// Payback link model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'payback_links'),
)
// ignore: must_be_immutable
class PaybackLink extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro payback_link_model}
  PaybackLink({
    required this.originalTransaction,
    required this.paybackTransaction,
    required this.createdAt,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Unique identifier for the payback link
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Transaction of the payback link
  @Supabase(
    foreignKey: 'transaction_id',
    name: 'transaction_id',
    fromGenerator:
        'await TransactionAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.originalTransaction.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Transaction originalTransaction;

  /// Payback transaction of the payback link
  @Supabase(
    foreignKey: 'payback_transaction_id',
    name: 'payback_transaction_id',
    fromGenerator:
        'await TransactionAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.paybackTransaction.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Transaction paybackTransaction;

  /// The date and time when the payback link was created
  final DateTime createdAt;

  /// Getter for the original transaction id
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get paybackTransactionId => paybackTransaction.id;

  /// Getter for the payback transaction id
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get originalTransactionId => originalTransaction.id;
  @override
  List<Object?> get props => [];
}
