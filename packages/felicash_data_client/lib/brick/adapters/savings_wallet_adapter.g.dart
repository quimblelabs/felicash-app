// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<SavingsWallet> _$SavingsWalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SavingsWallet(
    wallet: await WalletAdapter().fromSupabase(
      data['wallet'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    savingsGoal: data['savings_goal'] as double,
  );
}

Future<Map<String, dynamic>> _$SavingsWalletToSupabase(
  SavingsWallet instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'wallet': await WalletAdapter().toSupabase(
      instance.wallet,
      provider: provider,
      repository: repository,
    ),
    'savings_goal': instance.savingsGoal,
    'wallet_id': instance.walletId,
  };
}

Future<SavingsWallet> _$SavingsWalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SavingsWallet(
    wallet:
        (await repository!.getAssociation<Wallet>(
          Query.where(
            'primaryKey',
            data['wallet_Wallet_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    savingsGoal: data['savings_goal'] as double,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SavingsWalletToSqlite(
  SavingsWallet instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'wallet_Wallet_brick_id':
        instance.wallet.primaryKey ??
        await provider.upsert<Wallet>(instance.wallet, repository: repository),
    'savings_goal': instance.savingsGoal,
    'wallet_id': instance.walletId,
  };
}

/// Construct a [SavingsWallet]
class SavingsWalletAdapter
    extends OfflineFirstWithSupabaseAdapter<SavingsWallet> {
  SavingsWalletAdapter();

  @override
  final supabaseTableName = 'savings_wallets';
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
    'savingsGoal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'savings_goal',
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
    'savingsGoal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'savings_goal',
      iterable: false,
      type: double,
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
    SavingsWallet instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `SavingsWallet` WHERE wallet_id = ? LIMIT 1''',
      [instance.walletId],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'SavingsWallet';

  @override
  Future<SavingsWallet> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingsWalletFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    SavingsWallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingsWalletToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<SavingsWallet> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingsWalletFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    SavingsWallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SavingsWalletToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
