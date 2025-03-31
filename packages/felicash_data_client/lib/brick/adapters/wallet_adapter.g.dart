// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Wallet> _$WalletFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    walletType: WalletType.values.byName(data['wallet_type'] as String),
    name: data['name'] as String,
    description: data['description'] as String,
    baseCurrency: data['base_currency'] as String,
    balance: data['balance'] as double,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
    excludeFromTotal: data['exclude_from_total'] as bool,
    archived: data['archived'] as bool,
    archivedAt:
        data['archived_at'] == null
            ? null
            : data['archived_at'] == null
            ? null
            : DateTime.tryParse(data['archived_at'] as String),
    archiveReason:
        data['archive_reason'] == null
            ? null
            : data['archive_reason'] as String? ?? null,
  );
}

Future<Map<String, dynamic>> _$WalletToSupabase(
  Wallet instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'wallet_type': instance.walletType.toSupabase(),
    'name': instance.name,
    'description': instance.description,
    'base_currency': instance.baseCurrency,
    'balance': instance.balance,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'exclude_from_total': instance.excludeFromTotal,
    'archived': instance.archived,
    'archived_at': instance.archivedAt?.toIso8601String(),
    'archive_reason': instance.archiveReason,
  };
}

Future<Wallet> _$WalletFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Wallet(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    walletType: WalletType.values.byName(data['wallet_type'] as String),
    name: data['name'] as String,
    description: data['description'] as String,
    baseCurrency: data['base_currency'] as String,
    balance: data['balance'] as double,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
    excludeFromTotal: data['exclude_from_total'] == 1,
    archived: data['archived'] == 1,
    archivedAt:
        data['archived_at'] == null
            ? null
            : data['archived_at'] == null
            ? null
            : DateTime.tryParse(data['archived_at'] as String),
    archiveReason:
        data['archive_reason'] == null
            ? null
            : data['archive_reason'] as String? ?? null,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$WalletToSqlite(
  Wallet instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'profile_Profile_brick_id':
        instance.profile.primaryKey ??
        await provider.upsert<Profile>(
          instance.profile,
          repository: repository,
        ),
    'wallet_type': instance.walletType.name,
    'name': instance.name,
    'description': instance.description,
    'base_currency': instance.baseCurrency,
    'balance': instance.balance,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'exclude_from_total': instance.excludeFromTotal ? 1 : 0,
    'archived': instance.archived ? 1 : 0,
    'archived_at': instance.archivedAt?.toIso8601String(),
    'archive_reason': instance.archiveReason,
  };
}

/// Construct a [Wallet]
class WalletAdapter extends OfflineFirstWithSupabaseAdapter<Wallet> {
  WalletAdapter();

  @override
  final supabaseTableName = 'wallets';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'profile': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'user_id',
      associationType: Profile,
      associationIsNullable: false,
      foreignKey: 'user_id',
    ),
    'walletType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_type',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'baseCurrency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'base_currency',
    ),
    'balance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'balance',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'excludeFromTotal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'exclude_from_total',
    ),
    'archived': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'archived',
    ),
    'archivedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'archived_at',
    ),
    'archiveReason': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'archive_reason',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
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
    'profile': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'profile_Profile_brick_id',
      iterable: false,
      type: Profile,
    ),
    'walletType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wallet_type',
      iterable: false,
      type: WalletType,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'baseCurrency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'base_currency',
      iterable: false,
      type: String,
    ),
    'balance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'balance',
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
    'excludeFromTotal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'exclude_from_total',
      iterable: false,
      type: bool,
    ),
    'archived': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'archived',
      iterable: false,
      type: bool,
    ),
    'archivedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'archived_at',
      iterable: false,
      type: DateTime,
    ),
    'archiveReason': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'archive_reason',
      iterable: false,
      type: String,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Wallet instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Wallet` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Wallet';

  @override
  Future<Wallet> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Wallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Wallet> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WalletFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Wallet input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$WalletToSqlite(input, provider: provider, repository: repository);
}
