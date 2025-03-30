// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Merchant> _$MerchantFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Merchant(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    name: data['name'] as String,
    address: data['address'] == null ? null : data['address'] as String?,
    lat: data['lat'] == null ? null : data['lat'] as double?,
    lng: data['lng'] == null ? null : data['lng'] as double?,
    metadata:
        data['metadata'] == null
            ? null
            : data['metadata'] as Map<String, dynamic>,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$MerchantToSupabase(
  Merchant instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'name': instance.name,
    'address': instance.address,
    'lat': instance.lat,
    'lng': instance.lng,
    'metadata': instance.metadata,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<Merchant> _$MerchantFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Merchant(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    name: data['name'] as String,
    address: data['address'] == null ? null : data['address'] as String?,
    lat: data['lat'] == null ? null : data['lat'] as double?,
    lng: data['lng'] == null ? null : data['lng'] as double?,
    metadata:
        data['metadata'] == null
            ? null
            : jsonDecode(data['metadata'] as String) as Map<String, dynamic>,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MerchantToSqlite(
  Merchant instance, {
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
    'name': instance.name,
    'address': instance.address,
    'lat': instance.lat,
    'lng': instance.lng,
    'metadata':
        instance.metadata != null ? jsonEncode(instance.metadata) : null,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [Merchant]
class MerchantAdapter extends OfflineFirstWithSupabaseAdapter<Merchant> {
  MerchantAdapter();

  @override
  final supabaseTableName = 'merchants';
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
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'address': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'address',
    ),
    'lat': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lat',
    ),
    'lng': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'lng',
    ),
    'metadata': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'metadata',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'address': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'address',
      iterable: false,
      type: String,
    ),
    'lat': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lat',
      iterable: false,
      type: double,
    ),
    'lng': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'lng',
      iterable: false,
      type: double,
    ),
    'metadata': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'metadata',
      iterable: false,
      type: Map,
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
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Merchant instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Merchant` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Merchant';

  @override
  Future<Merchant> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MerchantFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Merchant input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MerchantToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Merchant> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MerchantFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Merchant input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MerchantToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
