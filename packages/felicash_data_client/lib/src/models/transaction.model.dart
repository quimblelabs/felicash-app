import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/enums/transaction_type.enum.dart';
import 'package:felicash_data_client/src/models/category.model.dart';
import 'package:felicash_data_client/src/models/merchant.model.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:felicash_data_client/src/models/recurrence.model.dart';
import 'package:felicash_data_client/src/models/wallet.model.dart';
import 'package:uuid/uuid.dart';

/// {@template transaction_model}
/// Transaction model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'transactions'),
)
// ignore: must_be_immutable
class Transaction extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro transaction_model}
  Transaction({
    required this.profile,
    required this.wallet,
    required this.transactionType,
    required this.amount,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.merchant,
    this.notes,
    this.imageAttachment,
    this.recurrence,
    this.transferId,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the transaction
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// User id of the transaction
  @Supabase(
    foreignKey: 'user_id',
    name: 'user_id',
    fromGenerator:
        'await ProfileAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.profile.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Profile profile;

  /// Wallet id of the transaction
  @Supabase(
    foreignKey: 'wallet_id',
    name: 'wallet_id',
    fromGenerator:
        'await WalletAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.wallet.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Wallet wallet;

  /// Category id of the transaction
  @Supabase(
    defaultValue: 'null',
    foreignKey: 'category_id',
    name: 'category_id',
    fromGenerator:
        'await CategoryAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.category?.id',
  )
  @Sqlite(
    defaultValue: 'null',
    onDeleteSetDefault: true,
    fromGenerator:
        '(%DATA_PROPERTY% as int > -1 '
        '? (await repository.getAssociation<Category>( '
        'Query.where("primaryKey", %DATA_PROPERTY% as int, limit1: true, '
        ')))?.first : null)',
  )
  final Category? category;

  /// Transaction type of the transaction
  @Supabase(
    enumAsString: true,
    fromGenerator: 'TransactionType.fromSupabase(%DATA_PROPERTY% as String)',
  )
  @Sqlite(enumAsString: true)
  final TransactionType transactionType;

  /// Amount of the transaction
  final double amount;

  /// Transaction date of the transaction
  final DateTime transactionDate;

  /// Notes of the transaction
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? notes;

  /// Image attachment of the transaction
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? imageAttachment;

  /// Recurrence id of the transaction
  @Supabase(
    defaultValue: 'null',
    foreignKey: 'recurrence_id',
    name: 'recurrence_id',
    fromGenerator:
        'await RecurrenceAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.recurrence?.id',
  )
  @Sqlite(
    defaultValue: 'null',
    onDeleteSetDefault: true,
    fromGenerator:
        '(%DATA_PROPERTY% as int > -1 '
        '? (await repository.getAssociation<Recurrence>( '
        'Query.where("primaryKey", %DATA_PROPERTY% as int, limit1: true, '
        ')))?.first : null)',
  )
  final Recurrence? recurrence;

  /// Transfer id of the transaction
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? transferId;

  /// Created at of the transaction
  final DateTime createdAt;

  /// Updated at of the transaction
  final DateTime updatedAt;

  /// Merchant id of the transaction
  @Supabase(
    defaultValue: 'null',
    foreignKey: 'merchant_id',
    name: 'merchant_id',
    fromGenerator:
        'await MerchantAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.merchant?.id',
  )
  @Sqlite(
    defaultValue: 'null',
    onDeleteSetDefault: true,
    fromGenerator:
        '(%DATA_PROPERTY% as int > -1 '
        '? (await repository.getAssociation<Merchant>( '
        'Query.where("primaryKey", %DATA_PROPERTY% as int, limit1: true, '
        ')))?.first : null)',
  )
  final Merchant? merchant;

  /// User id of the transaction
  @Supabase(ignoreTo: true)
  @Sqlite(ignore: true)
  String get userId => profile.id;

  /// Wallet id of the transaction
  @Supabase(ignoreTo: true)
  @Sqlite(ignore: true)
  String get walletId => wallet.id;

  /// Category id of the transaction
  @Supabase(ignoreTo: true)
  @Sqlite(ignore: true)
  String? get categoryId => category?.id;

  /// Recurrence id of the transaction
  @Supabase(ignoreTo: true)
  @Sqlite(ignore: true)
  String? get recurrenceId => recurrence?.id;

  /// Merchant id of the transaction
  @Supabase(ignoreTo: true)
  @Sqlite(ignore: true)
  String? get merchantId => merchant?.id;

  @override
  List<Object?> get props => [
    id,
    profile,
    wallet,
    category,
    transactionType,
    amount,
    transactionDate,
    notes,
    imageAttachment,
    recurrence,
    createdAt,
    updatedAt,
    merchant,
    transferId,
  ];
}
