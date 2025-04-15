import 'package:felicash_data_client/felicash_data_client.dart' show SqliteRow;
import 'package:felicash_data_client/src/enums/transaction_type.dart';
import 'package:felicash_data_client/src/models/category.dart';
import 'package:felicash_data_client/src/models/merchant.dart';
import 'package:felicash_data_client/src/models/profile.dart';
import 'package:felicash_data_client/src/models/recurrence.dart';
import 'package:felicash_data_client/src/models/wallet.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart' show SqliteRow;
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

/// {@template transaction_fields}
/// Transaction fields
/// {@endtemplate}
typedef TransactionFields = _$TransactionJsonKeys;

/// {@template transaction_model}
/// Transaction model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Transaction {
  /// {@macro transaction_model}
  Transaction({
    required this.transactionId,
    required this.transactionTransactionType,
    required this.transactionAmount,
    required this.transactionTransactionDate,
    required this.transactionNotes,
    required this.transactionImageAttachment,
    required this.transactionCreatedAt,
    required this.transactionUpdatedAt,
    required this.transactionMerchantId,
    required this.transactionUserId,
    required this.transactionWalletId,
    required this.transactionCategoryId,
    required this.transactionRecurrenceId,
    required this.transactionTransferId,
    this.transactions = const [],
    this.merchants = const [],
    this.categories = const [],
    this.profiles = const [],
    this.wallets = const [],
    this.recurrences = const [],
  }) : id = transactionId;

  /// Factory constructor for [Transaction] from [SqliteRow]
  factory Transaction.fromRow(SqliteRow row) {
    return Transaction(
      transactionId: row[TransactionFields.transactionId] as String,
      transactionTransactionType: TransactionType.values.byName(
        row[TransactionFields.transactionTransactionType] as String,
      ),
      transactionAmount: row[TransactionFields.transactionAmount] as double,
      transactionTransactionDate: DateTime.parse(
        row[TransactionFields.transactionTransactionDate] as String,
      ),
      transactionNotes: row[TransactionFields.transactionNotes] as String?,
      transactionImageAttachment:
          row[TransactionFields.transactionImageAttachment] as String?,
      transactionCreatedAt: DateTime.parse(
        row[TransactionFields.transactionCreatedAt] as String,
      ),
      transactionUpdatedAt: DateTime.parse(
        row[TransactionFields.transactionUpdatedAt] as String,
      ),
      transactionMerchantId:
          row[TransactionFields.transactionMerchantId] as String?,
      transactionUserId: row[TransactionFields.transactionUserId] as String,
      transactionWalletId: row[TransactionFields.transactionWalletId] as String,
      transactionCategoryId:
          row[TransactionFields.transactionCategoryId] as String?,
      transactionRecurrenceId:
          row[TransactionFields.transactionRecurrenceId] as String?,
      transactionTransferId:
          row[TransactionFields.transactionTransferId] as String?,
      transactions: [],
      merchants: [],
      categories: [],
      profiles: [],
      wallets: [],
      recurrences: [],
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the transaction
  final String transactionId;

  /// Transaction type of the transaction
  final TransactionType transactionTransactionType;

  /// Amount of the transaction
  final double transactionAmount;

  /// Transaction date of the transaction
  final DateTime transactionTransactionDate;

  /// Notes of the transaction
  final String? transactionNotes;

  /// Image attachment of the transaction
  final String? transactionImageAttachment;

  /// Created at of the transaction
  final DateTime transactionCreatedAt;

  /// Updated at of the transaction
  final DateTime transactionUpdatedAt;

  /// Transaction merchant id of the transaction
  final String? transactionMerchantId;

  /// Merchants of the transaction
  final List<Merchant> merchants;

  /// Transaction user id of the transaction
  final String transactionUserId;

  /// Profiles of the transaction
  final List<Profile> profiles;

  /// Transaction wallet id of the transaction
  final String transactionWalletId;

  /// Wallet id of the transaction
  final List<Wallet> wallets;

  /// Transaction category id of the transaction
  final String? transactionCategoryId;

  /// Categories of the transaction
  final List<Category> categories;

  /// Transaction recurrence id of the transaction
  final String? transactionRecurrenceId;

  /// Recurrences of the transaction
  final List<Recurrence> recurrences;

  /// Transaction transfer id of the transaction
  final String? transactionTransferId;

  /// Transfers of the transaction
  final List<Transaction> transactions;

  /// Creates a copy of this [Transaction] but with the given fields
  Transaction copyWith({
    String? transactionId,
    TransactionType? transactionTransactionType,
    double? transactionAmount,
    DateTime? transactionTransactionDate,
    String? transactionNotes,
    String? transactionImageAttachment,
    DateTime? transactionCreatedAt,
    DateTime? transactionUpdatedAt,
    String? transactionMerchantId,
    String? transactionUserId,
    String? transactionWalletId,
    String? transactionCategoryId,
    String? transactionRecurrenceId,
    String? transactionTransferId,
    List<Transaction>? transactions,
    List<Merchant>? merchants,
    List<Category>? categories,
    List<Profile>? profiles,
    List<Wallet>? wallets,
    List<Recurrence>? recurrences,
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      transactionTransactionType:
          transactionTransactionType ?? this.transactionTransactionType,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      transactionTransactionDate:
          transactionTransactionDate ?? this.transactionTransactionDate,
      transactionNotes: transactionNotes ?? this.transactionNotes,
      transactionImageAttachment:
          transactionImageAttachment ?? this.transactionImageAttachment,
      transactionCreatedAt: transactionCreatedAt ?? this.transactionCreatedAt,
      transactionUpdatedAt: transactionUpdatedAt ?? this.transactionUpdatedAt,
      transactionMerchantId:
          transactionMerchantId ?? this.transactionMerchantId,
      transactionUserId: transactionUserId ?? this.transactionUserId,
      transactionWalletId: transactionWalletId ?? this.transactionWalletId,
      transactionCategoryId:
          transactionCategoryId ?? this.transactionCategoryId,
      transactionRecurrenceId:
          transactionRecurrenceId ?? this.transactionRecurrenceId,
      transactionTransferId:
          transactionTransferId ?? this.transactionTransferId,
      transactions: transactions ?? this.transactions,
      merchants: merchants ?? this.merchants,
      categories: categories ?? this.categories,
      profiles: profiles ?? this.profiles,
      wallets: wallets ?? this.wallets,
      recurrences: recurrences ?? this.recurrences,
    );
  }
}
