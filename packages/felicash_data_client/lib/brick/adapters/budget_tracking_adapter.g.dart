// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BudgetTracking> _$BudgetTrackingFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BudgetTracking(
    transaction: await TransactionAdapter().fromSupabase(
      data['transaction_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    budget: await BudgetAdapter().fromSupabase(
      data['budget_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    amount: data['amount'] as double,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$BudgetTrackingToSupabase(
  BudgetTracking instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'transaction_id': instance.transaction.id,
    'budget_id': instance.budget.id,
    'amount': instance.amount,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<BudgetTracking> _$BudgetTrackingFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BudgetTracking(
    transaction:
        (await repository!.getAssociation<Transaction>(
          Query.where(
            'primaryKey',
            data['transaction_Transaction_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    budget:
        (await repository.getAssociation<Budget>(
          Query.where(
            'primaryKey',
            data['budget_Budget_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    amount: data['amount'] as double,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BudgetTrackingToSqlite(
  BudgetTracking instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'transaction_Transaction_brick_id':
        instance.transaction.primaryKey ??
        await provider.upsert<Transaction>(
          instance.transaction,
          repository: repository,
        ),
    'budget_Budget_brick_id':
        instance.budget.primaryKey ??
        await provider.upsert<Budget>(instance.budget, repository: repository),
    'amount': instance.amount,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [BudgetTracking]
class BudgetTrackingAdapter
    extends OfflineFirstWithSupabaseAdapter<BudgetTracking> {
  BudgetTrackingAdapter();

  @override
  final supabaseTableName = 'budget_trackings';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'transaction': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'transaction_id',
      associationType: Transaction,
      associationIsNullable: false,
      foreignKey: 'transaction_id',
    ),
    'budget': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'budget_id',
      associationType: Budget,
      associationIsNullable: false,
      foreignKey: 'budget_id',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'budgetId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'budget_id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'transaction': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'transaction_Transaction_brick_id',
      iterable: false,
      type: Transaction,
    ),
    'budget': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'budget_Budget_brick_id',
      iterable: false,
      type: Budget,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'budgetId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'budget_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    BudgetTracking instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'BudgetTracking';

  @override
  Future<BudgetTracking> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetTrackingFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BudgetTracking input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetTrackingToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<BudgetTracking> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetTrackingFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BudgetTracking input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetTrackingToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
