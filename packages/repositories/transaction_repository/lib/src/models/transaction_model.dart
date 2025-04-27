import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:recurrence_repository/recurrence_repository.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// {@template transaction_model}
/// Represents a financial transaction within a wallet.
/// {@endtemplate}
class TransactionModel extends Equatable {
  /// Creates a new instance of [TransactionModel].
  ///
  /// {@macro transaction_model}
  const TransactionModel({
    required this.id,
    required this.wallet,
    required this.transactionType,
    required this.amount,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.notes,
    this.imageAttachment,
    this.recurrence,
    this.transferWallet,
    this.transferTransaction,
  }) : merchantId = null;

  /// Factory constructor for [TransactionModel] from [Transaction]
  factory TransactionModel.fromTransaction(Transaction transaction) {
    final recurrence = transaction.recurrences.firstOrNull;
    final category = transaction.categories.firstOrNull;
    final wallet = transaction.wallets.firstOrNull;
    final transferWallet = transaction.wallets.firstOrNull;
    final transferTransaction = transaction.transactions.firstOrNull;
    return TransactionModel(
      id: transaction.transactionId,
      amount: transaction.transactionAmount,
      transactionDate: transaction.transactionTransactionDate,
      createdAt: transaction.transactionCreatedAt,
      updatedAt: transaction.transactionUpdatedAt,
      notes: transaction.transactionNotes,
      imageAttachment: transaction.transactionImageAttachment,
      recurrence: recurrence != null
          ? RecurrenceModel.fromRecurrence(recurrence)
          : null,
      category: category != null ? CategoryModel.fromCategory(category) : null,
      transactionType: TransactionTypeEnum.values.byName(
        transaction.transactionTransactionType.name,
      ),
      transferTransaction: transferTransaction != null
          ? TransactionModel.fromTransaction(transferTransaction)
          : null,
      wallet: wallet != null
          ? switch (wallet.walletWalletType) {
              WalletType.basic => BasicWalletModel.fromWallet(wallet: wallet),
              WalletType.credit => CreditWalletModel.fromWallet(wallet: wallet),
              WalletType.savings =>
                SavingsWalletModel.fromWallet(wallet: wallet),
              _ => throw UnimplementedError(),
            }
          : BasicWalletModel.empty,
      transferWallet: transferWallet != null
          ? switch (transferWallet.walletWalletType) {
              WalletType.basic =>
                BasicWalletModel.fromWallet(wallet: transferWallet),
              WalletType.credit => CreditWalletModel.fromWallet(
                  wallet: transferWallet,
                ),
              WalletType.savings =>
                SavingsWalletModel.fromWallet(wallet: transferWallet),
              _ => throw UnimplementedError(),
            }
          : null,
    );
  }

  /// Unique identifier for the transaction.
  final String id;

  /// The wallet associated with this transaction.
  final BaseWalletModel wallet;

  /// The category this transaction belongs to.
  final CategoryModel? category;

  /// Type of transaction (e.g., income, expense).
  final TransactionTypeEnum transactionType;

  /// The transaction amount.
  final double amount;

  /// The date and time the transaction occurred.
  final DateTime transactionDate;

  /// Additional notes for the transaction.
  final String? notes;

  /// Optional image attachment for the transaction (e.g., receipt).
  final String? imageAttachment;

  /// Optional recurrence details if the transaction repeats.
  final RecurrenceModel? recurrence;

  /// Timestamp when the transaction was created.
  final DateTime createdAt;

  /// Timestamp when the transaction was last updated.
  final DateTime updatedAt;

  /// The transaction wallet to this transaction if it is a transfer.
  final BaseWalletModel? transferWallet;

  /// The transaction linked to this transaction if it is a transfer.
  final TransactionModel? transferTransaction;

  /// The merchant ID for the transaction.
  final String? merchantId;

  /// Creates a copy of this model with optional new values.
  TransactionModel copyWith({
    String? id,
    BaseWalletModel? wallet,
    CategoryModel? category,
    TransactionTypeEnum? transactionType,
    double? amount,
    DateTime? transactionDate,
    String? notes,
    String? imageAttachment,
    RecurrenceModel? recurrence,
    DateTime? createdAt,
    DateTime? updatedAt,
    BaseWalletModel? transferWallet,
    TransactionModel? transferTransaction,
    String? merchantId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      wallet: wallet ?? this.wallet,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      imageAttachment: imageAttachment ?? this.imageAttachment,
      recurrence: recurrence ?? this.recurrence,
      transferWallet: transferWallet ?? this.transferWallet,
      transferTransaction: transferTransaction ?? this.transferTransaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty transaction model.
  static TransactionModel empty = TransactionModel(
    id: '',
    wallet: BasicWalletModel.empty,
    category: CategoryModel.empty,
    transactionType: TransactionTypeEnum.expense,
    amount: 0,
    transactionDate: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
        id,
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
        transferWallet,
        transferTransaction,
      ];

  @override
  bool get stringify => true;
}
