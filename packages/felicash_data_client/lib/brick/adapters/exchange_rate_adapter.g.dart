// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ExchangeRate> _$ExchangeRateFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ExchangeRate(
    id: data['id'] as String?,
    fromCurrency: data['from_currency'] as String,
    toCurrency: data['to_currency'] as String,
    rate: data['rate'] as double,
    effectiveDate: DateTime.parse(data['effective_date'] as String),
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$ExchangeRateToSupabase(
  ExchangeRate instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'from_currency': instance.fromCurrency,
    'to_currency': instance.toCurrency,
    'rate': instance.rate,
    'effective_date': instance.effectiveDate.toIso8601String(),
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<ExchangeRate> _$ExchangeRateFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ExchangeRate(
    id: data['id'] as String,
    fromCurrency: data['from_currency'] as String,
    toCurrency: data['to_currency'] as String,
    rate: data['rate'] as double,
    effectiveDate: DateTime.parse(data['effective_date'] as String),
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ExchangeRateToSqlite(
  ExchangeRate instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'from_currency': instance.fromCurrency,
    'to_currency': instance.toCurrency,
    'rate': instance.rate,
    'effective_date': instance.effectiveDate.toIso8601String(),
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [ExchangeRate]
class ExchangeRateAdapter
    extends OfflineFirstWithSupabaseAdapter<ExchangeRate> {
  ExchangeRateAdapter();

  @override
  final supabaseTableName = 'exchange_rates';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'fromCurrency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'from_currency',
    ),
    'toCurrency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'to_currency',
    ),
    'rate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rate',
    ),
    'effectiveDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'effective_date',
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
    'fromCurrency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'from_currency',
      iterable: false,
      type: String,
    ),
    'toCurrency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'to_currency',
      iterable: false,
      type: String,
    ),
    'rate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rate',
      iterable: false,
      type: double,
    ),
    'effectiveDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'effective_date',
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
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ExchangeRate instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `ExchangeRate` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ExchangeRate';

  @override
  Future<ExchangeRate> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ExchangeRateFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ExchangeRate input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ExchangeRateToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ExchangeRate> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ExchangeRateFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ExchangeRate input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ExchangeRateToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
