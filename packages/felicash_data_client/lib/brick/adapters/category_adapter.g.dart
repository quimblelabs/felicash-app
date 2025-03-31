// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Category> _$CategoryFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Category(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    parentCategoryId:
        data['parent_category_id'] == null
            ? null
            : data['parent_category_id'] as String?,
    transactionType: TransactionType.fromSupabase(
      data['transaction_type'] as String,
    ),
    name: data['name'] as String,
    icon: data['icon'] == null ? null : data['icon'] as String? ?? null,
    color: data['color'] == null ? null : data['color'] as String? ?? null,
    description:
        data['description'] == null
            ? null
            : data['description'] as String? ?? null,
    enabled: data['enabled'] as bool,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$CategoryToSupabase(
  Category instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'parent_category_id': instance.parentCategoryId,
    'transaction_type': instance.transactionType.toSupabase(),
    'name': instance.name,
    'icon': instance.icon,
    'color': instance.color,
    'description': instance.description,
    'enabled': instance.enabled,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<Category> _$CategoryFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Category(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    parentCategoryId:
        data['parent_category_id'] == null
            ? null
            : data['parent_category_id'] as String?,
    transactionType: TransactionType.values.byName(
      data['transaction_type'] as String,
    ),
    name: data['name'] as String,
    icon: data['icon'] == null ? null : data['icon'] as String? ?? null,
    color: data['color'] == null ? null : data['color'] as String? ?? null,
    description:
        data['description'] == null
            ? null
            : data['description'] as String? ?? null,
    enabled: data['enabled'] == 1,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CategoryToSqlite(
  Category instance, {
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
    'parent_category_id': instance.parentCategoryId,
    'transaction_type': instance.transactionType.name,
    'name': instance.name,
    'icon': instance.icon,
    'color': instance.color,
    'description': instance.description,
    'enabled': instance.enabled ? 1 : 0,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [Category]
class CategoryAdapter extends OfflineFirstWithSupabaseAdapter<Category> {
  CategoryAdapter();

  @override
  final supabaseTableName = 'categories';
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
    'parentCategoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'parent_category_id',
    ),
    'transactionType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_type',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'icon': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'icon',
    ),
    'color': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'color',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'enabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'enabled',
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
    'parentCategoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'parent_category_id',
      iterable: false,
      type: String,
    ),
    'transactionType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_type',
      iterable: false,
      type: TransactionType,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'icon': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'icon',
      iterable: false,
      type: String,
    ),
    'color': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'color',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'enabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'enabled',
      iterable: false,
      type: bool,
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
    Category instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Category` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Category';

  @override
  Future<Category> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CategoryFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Category input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CategoryToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Category> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CategoryFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Category input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CategoryToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
