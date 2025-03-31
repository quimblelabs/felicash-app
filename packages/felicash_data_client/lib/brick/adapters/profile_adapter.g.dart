// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Profile> _$ProfileFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Profile(
    id: data['id'] as String?,
    fcmToken: data['fcm_token'] == null ? null : data['fcm_token'] as String?,
  );
}

Future<Map<String, dynamic>> _$ProfileToSupabase(
  Profile instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'id': instance.id, 'fcm_token': instance.fcmToken};
}

Future<Profile> _$ProfileFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Profile(
    id: data['id'] as String,
    fcmToken: data['fcm_token'] == null ? null : data['fcm_token'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ProfileToSqlite(
  Profile instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'id': instance.id, 'fcm_token': instance.fcmToken};
}

/// Construct a [Profile]
class ProfileAdapter extends OfflineFirstWithSupabaseAdapter<Profile> {
  ProfileAdapter();

  @override
  final supabaseTableName = 'profiles';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'fcmToken': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'fcm_token',
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
    'fcmToken': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'fcm_token',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Profile instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Profile` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Profile';

  @override
  Future<Profile> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Profile input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Profile> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Profile input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ProfileToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
