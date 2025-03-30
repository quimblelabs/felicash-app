// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Currency> _$CurrencyFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Currency(
    code: data['code'] as String,
    name: data['name'] as String,
    symbol: data['symbol'] as String,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$CurrencyToSupabase(
  Currency instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'code': instance.code,
    'name': instance.name,
    'symbol': instance.symbol,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<Currency> _$CurrencyFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Currency(
    code: data['code'] as String,
    name: data['name'] as String,
    symbol: data['symbol'] as String,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CurrencyToSqlite(
  Currency instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'code': instance.code,
    'name': instance.name,
    'symbol': instance.symbol,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [Currency]
class CurrencyAdapter extends OfflineFirstWithSupabaseAdapter<Currency> {
  CurrencyAdapter();

  @override
  final supabaseTableName = 'currencies';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'code': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'code',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'symbol': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'symbol',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'code'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'code': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'code',
      iterable: false,
      type: String,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'symbol': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'symbol',
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
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Currency instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Currency` WHERE code = ? LIMIT 1''',
      [instance.code],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Currency';

  @override
  Future<Currency> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CurrencyFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Currency input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CurrencyToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Currency> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CurrencyFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Currency input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CurrencyToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
