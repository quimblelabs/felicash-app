// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<CreditWallet> _$CreditWalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return CreditWallet(
    wallet: await WalletAdapter().fromSupabase(
      data['wallet'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    creditLimit: data['credit_limit'] as double,
    stateDayOfMonth: data['state_day_of_month'] as int,
    paymentDueDayOfMonth: data['payment_due_day_of_month'] as int,
  );
}

Future<Map<String, dynamic>> _$CreditWalletToSupabase(
  CreditWallet instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'wallet': await WalletAdapter().toSupabase(
      instance.wallet,
      provider: provider,
      repository: repository,
    ),
    'credit_limit': instance.creditLimit,
    'state_day_of_month': instance.stateDayOfMonth,
    'payment_due_day_of_month': instance.paymentDueDayOfMonth,
    'wallet_id': instance.walletId,
  };
}

Future<CreditWallet> _$CreditWalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return CreditWallet(
    wallet:
        (await repository!.getAssociation<Wallet>(
          Query.where(
            'primaryKey',
            data['wallet_Wallet_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    creditLimit: data['credit_limit'] as double,
    stateDayOfMonth: data['state_day_of_month'] as int,
    paymentDueDayOfMonth: data['payment_due_day_of_month'] as int,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CreditWalletToSqlite(
  CreditWallet instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'wallet_Wallet_brick_id':
        instance.wallet.primaryKey ??
        await provider.upsert<Wallet>(instance.wallet, repository: repository),
    'credit_limit': instance.creditLimit,
    'state_day_of_month': instance.stateDayOfMonth,
    'payment_due_day_of_month': instance.paymentDueDayOfMonth,
    'wallet_id': instance.walletId,
  };
}

/// Construct a [CreditWallet]
class CreditWalletAdapter
    extends OfflineFirstWithSupabaseAdapter<CreditWallet> {
  CreditWalletAdapter();

  @override
  final supabaseTableName = 'credit_wallets';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'wallet': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'wallet',
      associationType: Wallet,
      associationIsNullable: false,
      foreignKey: 'wallet_id',
    ),
    'creditLimit': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'credit_limit',
    ),
    'stateDayOfMonth': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'state_day_of_month',
    ),
    'paymentDueDayOfMonth': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_due_day_of_month',
    ),
    'walletId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'walletId'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'wallet': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'wallet_Wallet_brick_id',
      iterable: false,
      type: Wallet,
    ),
    'creditLimit': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'credit_limit',
      iterable: false,
      type: double,
    ),
    'stateDayOfMonth': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'state_day_of_month',
      iterable: false,
      type: int,
    ),
    'paymentDueDayOfMonth': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_due_day_of_month',
      iterable: false,
      type: int,
    ),
    'walletId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    CreditWallet instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `CreditWallet` WHERE wallet_id = ? LIMIT 1''',
      [instance.walletId],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'CreditWallet';

  @override
  Future<CreditWallet> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CreditWalletFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    CreditWallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CreditWalletToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<CreditWallet> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CreditWalletFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    CreditWallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CreditWalletToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
