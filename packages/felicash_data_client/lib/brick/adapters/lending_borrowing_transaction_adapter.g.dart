// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<LendingBorrowingTransaction> _$LendingBorrowingTransactionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return LendingBorrowingTransaction(
    transaction: await TransactionAdapter().fromSupabase(
      data['transaction_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    counterParty:
        data['counter_party_id'] == null
            ? null
            : await ProfileAdapter().fromSupabase(
              data['counter_party_id'] as Map<String, dynamic>,
              provider: provider,
              repository: repository,
            ),
    counterPartyName:
        data['counter_party_name'] == null
            ? null
            : data['counter_party_name'] as String?,
    paybackAmount: data['payback_amount'] as double,
  );
}

Future<Map<String, dynamic>> _$LendingBorrowingTransactionToSupabase(
  LendingBorrowingTransaction instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'transaction_id': instance.transaction.id,
    'counter_party_id': instance.counterParty?.id,
    'counter_party_name': instance.counterPartyName,
    'payback_amount': instance.paybackAmount,
  };
}

Future<LendingBorrowingTransaction> _$LendingBorrowingTransactionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return LendingBorrowingTransaction(
    transaction:
        (await repository!.getAssociation<Transaction>(
          Query.where(
            'primaryKey',
            data['transaction_Transaction_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    counterParty:
        data['counter_party_Profile_brick_id'] == null
            ? null
            : (data['counter_party_Profile_brick_id'] as int > -1
                ? (await repository.getAssociation<Profile>(
                  Query.where(
                    "primaryKey",
                    data['counter_party_Profile_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    counterPartyName:
        data['counter_party_name'] == null
            ? null
            : data['counter_party_name'] as String?,
    paybackAmount: data['payback_amount'] as double,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$LendingBorrowingTransactionToSqlite(
  LendingBorrowingTransaction instance, {
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
    'counter_party_Profile_brick_id':
        instance.counterParty != null
            ? instance.counterParty!.primaryKey ??
                await provider.upsert<Profile>(
                  instance.counterParty!,
                  repository: repository,
                )
            : null,
    'counter_party_name': instance.counterPartyName,
    'payback_amount': instance.paybackAmount,
  };
}

/// Construct a [LendingBorrowingTransaction]
class LendingBorrowingTransactionAdapter
    extends OfflineFirstWithSupabaseAdapter<LendingBorrowingTransaction> {
  LendingBorrowingTransactionAdapter();

  @override
  final supabaseTableName = 'lending_borrowing_transactions';
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
    'counterParty': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'counter_party_id',
      associationType: Profile,
      associationIsNullable: true,
      foreignKey: 'counter_party_id',
    ),
    'counterPartyName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'counter_party_name',
    ),
    'paybackAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payback_amount',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'counterPartyId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'counter_party_id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'transactionId'};
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
    'counterParty': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'counter_party_Profile_brick_id',
      iterable: false,
      type: Profile,
    ),
    'counterPartyName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'counter_party_name',
      iterable: false,
      type: String,
    ),
    'paybackAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payback_amount',
      iterable: false,
      type: double,
    ),
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'counterPartyId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'counter_party_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    LendingBorrowingTransaction instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `LendingBorrowingTransaction` WHERE transaction_id = ? LIMIT 1''',
      [instance.transactionId],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'LendingBorrowingTransaction';

  @override
  Future<LendingBorrowingTransaction> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LendingBorrowingTransactionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    LendingBorrowingTransaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LendingBorrowingTransactionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<LendingBorrowingTransaction> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LendingBorrowingTransactionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    LendingBorrowingTransaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LendingBorrowingTransactionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
