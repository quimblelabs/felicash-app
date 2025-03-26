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
    'wallet': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'wallet_Wallet_brick_id',
      iterable: false,
      type: Wallet,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    CreditWallet instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
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
