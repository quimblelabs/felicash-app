// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Budget> _$BudgetFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Budget(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    category: await CategoryAdapter().fromSupabase(
      data['category_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    period: BudgetPeriod.fromSupabase(data['period'] as String),
    amount: data['amount'] as double,
    startDate: DateTime.parse(data['start_date'] as String),
    endDate: DateTime.parse(data['end_date'] as String),
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$BudgetToSupabase(
  Budget instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'category_id': instance.category.id,
    'period': instance.period.toSupabase(),
    'amount': instance.amount,
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<Budget> _$BudgetFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Budget(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    category:
        (await repository.getAssociation<Category>(
          Query.where(
            'primaryKey',
            data['category_Category_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    period: BudgetPeriod.values.byName(data['period'] as String),
    amount: data['amount'] as double,
    startDate: DateTime.parse(data['start_date'] as String),
    endDate: DateTime.parse(data['end_date'] as String),
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BudgetToSqlite(
  Budget instance, {
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
    'category_Category_brick_id':
        instance.category.primaryKey ??
        await provider.upsert<Category>(
          instance.category,
          repository: repository,
        ),
    'period': instance.period.name,
    'amount': instance.amount,
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [Budget]
class BudgetAdapter extends OfflineFirstWithSupabaseAdapter<Budget> {
  BudgetAdapter();

  @override
  final supabaseTableName = 'budgets';
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
    'category': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'category_id',
      associationType: Category,
      associationIsNullable: false,
      foreignKey: 'category_id',
    ),
    'period': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'period',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'startDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'start_date',
    ),
    'endDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'end_date',
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
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
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
    'category': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'category_Category_brick_id',
      iterable: false,
      type: Category,
    ),
    'period': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'period',
      iterable: false,
      type: BudgetPeriod,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
    ),
    'startDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'start_date',
      iterable: false,
      type: DateTime,
    ),
    'endDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'end_date',
      iterable: false,
      type: DateTime,
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
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Budget instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Budget` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Budget';

  @override
  Future<Budget> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Budget input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Budget> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BudgetFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Budget input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BudgetToSqlite(input, provider: provider, repository: repository);
}
