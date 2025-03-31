import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/budget.model.dart';
import 'package:felicash_data_client/src/models/transaction.model.dart';

/// {@template budget_tracking}
/// Model for budget tracking entries.
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'budget_trackings'),
)
// ignore: must_be_immutable
class BudgetTracking extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro budget_tracking}

  BudgetTracking({
    required this.transaction,
    required this.budget,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the budget tracking entry
  @Supabase(
    foreignKey: 'transaction_id',
    name: 'transaction_id',
    fromGenerator:
        'await TransactionAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.transaction.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Transaction transaction;

  /// Unique identifier for the budget
  @Supabase(
    foreignKey: 'budget_id',
    name: 'budget_id',
    fromGenerator:
        'await BudgetAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.budget.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Budget budget;

  /// Amount of the budget tracking entry
  final double amount;

  /// Timestamp when the budget tracking entry was created
  final DateTime createdAt;

  /// Timestamp when the budget tracking entry was last updated
  final DateTime updatedAt;

  /// Unique identifier for the budget tracking entry
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get transactionId => transaction.id;

  /// Unique identifier for the budget
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get budgetId => budget.id;

  @override
  List<Object?> get props => [
    transactionId,
    budgetId,
    amount,
    createdAt,
    updatedAt,
  ];
}
