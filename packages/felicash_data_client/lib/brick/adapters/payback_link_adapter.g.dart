// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<PaybackLink> _$PaybackLinkFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PaybackLink(
    id: data['id'] as String?,
    originalTransaction: await TransactionAdapter().fromSupabase(
      data['transaction_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    paybackTransaction: await TransactionAdapter().fromSupabase(
      data['payback_transaction_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    createdAt: DateTime.parse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$PaybackLinkToSupabase(
  PaybackLink instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'transaction_id': instance.originalTransaction.id,
    'payback_transaction_id': instance.paybackTransaction.id,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

Future<PaybackLink> _$PaybackLinkFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PaybackLink(
    id: data['id'] as String,
    originalTransaction:
        (await repository!.getAssociation<Transaction>(
          Query.where(
            'primaryKey',
            data['original_transaction_Transaction_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    paybackTransaction:
        (await repository.getAssociation<Transaction>(
          Query.where(
            'primaryKey',
            data['payback_transaction_Transaction_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    createdAt: DateTime.parse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PaybackLinkToSqlite(
  PaybackLink instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'original_transaction_Transaction_brick_id':
        instance.originalTransaction.primaryKey ??
        await provider.upsert<Transaction>(
          instance.originalTransaction,
          repository: repository,
        ),
    'payback_transaction_Transaction_brick_id':
        instance.paybackTransaction.primaryKey ??
        await provider.upsert<Transaction>(
          instance.paybackTransaction,
          repository: repository,
        ),
    'created_at': instance.createdAt.toIso8601String(),
  };
}

/// Construct a [PaybackLink]
class PaybackLinkAdapter extends OfflineFirstWithSupabaseAdapter<PaybackLink> {
  PaybackLinkAdapter();

  @override
  final supabaseTableName = 'payback_links';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'originalTransaction': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'transaction_id',
      associationType: Transaction,
      associationIsNullable: false,
      foreignKey: 'transaction_id',
    ),
    'paybackTransaction': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'payback_transaction_id',
      associationType: Transaction,
      associationIsNullable: false,
      foreignKey: 'payback_transaction_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'paybackTransactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payback_transaction_id',
    ),
    'originalTransactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'original_transaction_id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'originalTransaction': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'original_transaction_Transaction_brick_id',
      iterable: false,
      type: Transaction,
    ),
    'paybackTransaction': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'payback_transaction_Transaction_brick_id',
      iterable: false,
      type: Transaction,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'paybackTransactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payback_transaction_id',
      iterable: false,
      type: String,
    ),
    'originalTransactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'original_transaction_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    PaybackLink instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `PaybackLink` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'PaybackLink';

  @override
  Future<PaybackLink> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PaybackLinkFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    PaybackLink input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PaybackLinkToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<PaybackLink> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PaybackLinkFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    PaybackLink input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PaybackLinkToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
