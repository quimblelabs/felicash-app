import 'package:felicash_data_client/src/models/wallet.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:powersync/sqlite3.dart' as sqlite;
part 'saving_wallet.g.dart';

/// {@template wallet_fields}
/// Savings wallet fields
/// {@endtemplate}
typedef SavingsWalletFields = _$SavingsWalletJsonKeys;

/// {@template savings_wallet_model}
/// Savings wallet model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
// ignore: must_be_immutable
class SavingsWallet {
  /// {@macro savings_wallet_model}
  SavingsWallet({
    required this.savingsWalletId,
    required this.savingsWalletWalletId,
    required this.savingsWalletSavingsGoal,
    this.wallets = const [],
  }) : id = savingsWalletId;

  /// Creates a savings wallet from a row.
  factory SavingsWallet.fromRow(sqlite.Row row) {
    return SavingsWallet(
      savingsWalletId: row[SavingsWalletFields.savingsWalletId] as String,
      savingsWalletWalletId:
          row[SavingsWalletFields.savingsWalletWalletId] as String,
      savingsWalletSavingsGoal:
          row[SavingsWalletFields.savingsWalletSavingsGoal] as double,
      wallets: [],
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Savings wallet id of the savings wallet
  final String savingsWalletId;

  /// Savings goal of the savings wallet
  final double savingsWalletSavingsGoal;

  /// Wallet of the credit wallet which is relate to wallet table
  /// in database on wallet_id column
  final String savingsWalletWalletId;

  /// List of wallets of the credit wallet which is relate to wallet table
  /// in database on wallet_id column
  final List<Wallet> wallets;

  /// Creates a copy of the savings wallet with the given fields replaced with
  /// the new values.
  SavingsWallet copyWith({
    String? savingsWalletId,
    String? savingsWalletWalletId,
    double? savingsWalletSavingsGoal,
    List<Wallet>? wallets,
  }) {
    return SavingsWallet(
      savingsWalletId: savingsWalletId ?? this.savingsWalletId,
      savingsWalletWalletId:
          savingsWalletWalletId ?? this.savingsWalletWalletId,
      savingsWalletSavingsGoal:
          savingsWalletSavingsGoal ?? this.savingsWalletSavingsGoal,
      wallets: wallets ?? this.wallets,
    );
  }
}
