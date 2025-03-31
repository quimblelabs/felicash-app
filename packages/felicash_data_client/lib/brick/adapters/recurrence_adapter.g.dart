// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Recurrence> _$RecurrenceFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Recurrence(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    cronString:
        data['cron_string'] == null ? null : data['cron_string'] as String?,
    recurrenceType: RecurrenceType.fromSupabase(
      data['recurrence_type'] as String,
    ),
    description:
        data['description'] == null ? null : data['description'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$RecurrenceToSupabase(
  Recurrence instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'cron_string': instance.cronString,
    'recurrence_type': instance.recurrenceType.toSupabase(),
    'description': instance.description,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<Recurrence> _$RecurrenceFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Recurrence(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    cronString:
        data['cron_string'] == null ? null : data['cron_string'] as String?,
    recurrenceType: RecurrenceType.values.byName(
      data['recurrence_type'] as String,
    ),
    description:
        data['description'] == null ? null : data['description'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$RecurrenceToSqlite(
  Recurrence instance, {
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
    'cron_string': instance.cronString,
    'recurrence_type': instance.recurrenceType.name,
    'description': instance.description,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [Recurrence]
class RecurrenceAdapter extends OfflineFirstWithSupabaseAdapter<Recurrence> {
  RecurrenceAdapter();

  @override
  final supabaseTableName = 'recurrences';
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
    'cronString': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cron_string',
    ),
    'recurrenceType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recurrence_type',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
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
    'cronString': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cron_string',
      iterable: false,
      type: String,
    ),
    'recurrenceType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recurrence_type',
      iterable: false,
      type: RecurrenceType,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
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
    Recurrence instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Recurrence` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Recurrence';

  @override
  Future<Recurrence> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RecurrenceFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Recurrence input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RecurrenceToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Recurrence> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RecurrenceFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Recurrence input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RecurrenceToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
