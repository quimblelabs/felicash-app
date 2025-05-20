import 'package:category_repository/category_repository.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recurrence_repository/recurrence_repository.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// {@template transaction_model}
/// Represents a financial transaction within a wallet.
/// {@endtemplate}
@freezed
abstract class TransactionModel with _$TransactionModel {
  /// Creates a new instance of [TransactionModel].
  ///
  /// {@macro transaction_model}
  factory TransactionModel({
    required String id,
    required BaseWalletModel wallet,
    required TransactionTypeEnum transactionType,
    required double amount,
    required DateTime transactionDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    CategoryModel? category,
    String? notes,
    String? imageAttachment,
    RecurrenceModel? recurrence,
    BaseWalletModel? transferWallet,
    TransactionModel? transferTransaction,
    String? merchantId,
  }) = _TransactionModel;

  /// Creates a new instance of [TransactionModel] from JSON.
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

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
}
