// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Transaction> _$TransactionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Transaction(
    id: data['id'] as String?,
    profile: await ProfileAdapter().fromSupabase(
      data['user_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    wallet: await WalletAdapter().fromSupabase(
      data['wallet_id'] as Map<String, dynamic>,
      provider: provider,
      repository: repository,
    ),
    category:
        data['category_id'] == null
            ? null
            : await CategoryAdapter().fromSupabase(
              data['category_id'] as Map<String, dynamic>,
              provider: provider,
              repository: repository,
            ),
    transactionType: TransactionType.fromSupabase(
      data['transaction_type'] as String,
    ),
    amount: data['amount'] as double,
    transactionDate: DateTime.parse(data['transaction_date'] as String),
    notes: data['notes'] == null ? null : data['notes'] as String? ?? null,
    imageAttachment:
        data['image_attachment'] == null
            ? null
            : data['image_attachment'] as String? ?? null,
    recurrence:
        data['recurrence_id'] == null
            ? null
            : await RecurrenceAdapter().fromSupabase(
              data['recurrence_id'] as Map<String, dynamic>,
              provider: provider,
              repository: repository,
            ),
    transferId:
        data['transfer_id'] == null
            ? null
            : data['transfer_id'] as String? ?? null,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
    merchant:
        data['merchant_id'] == null
            ? null
            : await MerchantAdapter().fromSupabase(
              data['merchant_id'] as Map<String, dynamic>,
              provider: provider,
              repository: repository,
            ),
  );
}

Future<Map<String, dynamic>> _$TransactionToSupabase(
  Transaction instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.profile.id,
    'wallet_id': instance.wallet.id,
    'category_id': instance.category?.id,
    'transaction_type': instance.transactionType.toSupabase(),
    'amount': instance.amount,
    'transaction_date': instance.transactionDate.toIso8601String(),
    'notes': instance.notes,
    'image_attachment': instance.imageAttachment,
    'recurrence_id': instance.recurrence?.id,
    'transfer_id': instance.transferId,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'merchant_id': instance.merchant?.id,
  };
}

Future<Transaction> _$TransactionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Transaction(
    id: data['id'] as String,
    profile:
        (await repository!.getAssociation<Profile>(
          Query.where(
            'primaryKey',
            data['profile_Profile_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    wallet:
        (await repository.getAssociation<Wallet>(
          Query.where(
            'primaryKey',
            data['wallet_Wallet_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    category:
        data['category_Category_brick_id'] == null
            ? null
            : (data['category_Category_brick_id'] as int > -1
                ? (await repository.getAssociation<Category>(
                  Query.where(
                    "primaryKey",
                    data['category_Category_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    transactionType: TransactionType.values.byName(
      data['transaction_type'] as String,
    ),
    amount: data['amount'] as double,
    transactionDate: DateTime.parse(data['transaction_date'] as String),
    notes: data['notes'] == null ? null : data['notes'] as String? ?? null,
    imageAttachment:
        data['image_attachment'] == null
            ? null
            : data['image_attachment'] as String? ?? null,
    recurrence:
        data['recurrence_Recurrence_brick_id'] == null
            ? null
            : (data['recurrence_Recurrence_brick_id'] as int > -1
                ? (await repository.getAssociation<Recurrence>(
                  Query.where(
                    "primaryKey",
                    data['recurrence_Recurrence_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    transferId:
        data['transfer_id'] == null
            ? null
            : data['transfer_id'] as String? ?? null,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
    merchant:
        data['merchant_Merchant_brick_id'] == null
            ? null
            : (data['merchant_Merchant_brick_id'] as int > -1
                ? (await repository.getAssociation<Merchant>(
                  Query.where(
                    "primaryKey",
                    data['merchant_Merchant_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionToSqlite(
  Transaction instance, {
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
    'wallet_Wallet_brick_id':
        instance.wallet.primaryKey ??
        await provider.upsert<Wallet>(instance.wallet, repository: repository),
    'category_Category_brick_id':
        instance.category != null
            ? instance.category!.primaryKey ??
                await provider.upsert<Category>(
                  instance.category!,
                  repository: repository,
                )
            : null,
    'transaction_type': instance.transactionType.name,
    'amount': instance.amount,
    'transaction_date': instance.transactionDate.toIso8601String(),
    'notes': instance.notes,
    'image_attachment': instance.imageAttachment,
    'recurrence_Recurrence_brick_id':
        instance.recurrence != null
            ? instance.recurrence!.primaryKey ??
                await provider.upsert<Recurrence>(
                  instance.recurrence!,
                  repository: repository,
                )
            : null,
    'transfer_id': instance.transferId,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'merchant_Merchant_brick_id':
        instance.merchant != null
            ? instance.merchant!.primaryKey ??
                await provider.upsert<Merchant>(
                  instance.merchant!,
                  repository: repository,
                )
            : null,
  };
}

/// Construct a [Transaction]
class TransactionAdapter extends OfflineFirstWithSupabaseAdapter<Transaction> {
  TransactionAdapter();

  @override
  final supabaseTableName = 'transactions';
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
    'wallet': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'wallet_id',
      associationType: Wallet,
      associationIsNullable: false,
      foreignKey: 'wallet_id',
    ),
    'category': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'category_id',
      associationType: Category,
      associationIsNullable: true,
      foreignKey: 'category_id',
    ),
    'transactionType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_type',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'transactionDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_date',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'imageAttachment': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_attachment',
    ),
    'recurrence': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'recurrence_id',
      associationType: Recurrence,
      associationIsNullable: true,
      foreignKey: 'recurrence_id',
    ),
    'transferId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transfer_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'merchant': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'merchant_id',
      associationType: Merchant,
      associationIsNullable: true,
      foreignKey: 'merchant_id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'walletId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wallet_id',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'recurrenceId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recurrence_id',
    ),
    'merchantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'merchant_id',
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
    'wallet': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'wallet_Wallet_brick_id',
      iterable: false,
      type: Wallet,
    ),
    'category': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'category_Category_brick_id',
      iterable: false,
      type: Category,
    ),
    'transactionType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_type',
      iterable: false,
      type: TransactionType,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
    ),
    'transactionDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_date',
      iterable: false,
      type: DateTime,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'imageAttachment': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_attachment',
      iterable: false,
      type: String,
    ),
    'recurrence': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'recurrence_Recurrence_brick_id',
      iterable: false,
      type: Recurrence,
    ),
    'transferId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transfer_id',
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
    'merchant': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'merchant_Merchant_brick_id',
      iterable: false,
      type: Merchant,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Transaction instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Transaction` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Transaction';

  @override
  Future<Transaction> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Transaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Transaction> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Transaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
