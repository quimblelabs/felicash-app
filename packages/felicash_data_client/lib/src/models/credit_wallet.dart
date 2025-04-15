import 'package:felicash_data_client/src/models/models.dart';
import 'package:felicash_data_client/src/models/wallet.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

part 'credit_wallet.g.dart';

/// {@template wallet_fields}
/// Wallet fields
/// {@endtemplate}
typedef CreditWalletFields = _$CreditWalletJsonKeys;

/// {@template credit_wallet_model}
/// Credit wallet model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class CreditWallet {
  /// {@macro credit_wallet_model}
  const CreditWallet({
    required this.creditWalletId,
    required this.creditWalletWalletId,
    required this.creditWalletCreditLimit,
    required this.creditWalletStateDayOfMonth,
    required this.creditWalletPaymentDueDayOfMonth,
  }) : id = creditWalletId;

  /// Creates a credit wallet from a row.
  factory CreditWallet.fromRow(SqliteRow row) {
    return CreditWallet(
      creditWalletId: row[CreditWalletFields.creditWalletId] as String,
      creditWalletWalletId:
          row[CreditWalletFields.creditWalletWalletId] as String,
      creditWalletCreditLimit:
          row[CreditWalletFields.creditWalletCreditLimit] as double,
      creditWalletStateDayOfMonth:
          row[CreditWalletFields.creditWalletStateDayOfMonth] as int,
      creditWalletPaymentDueDayOfMonth:
          row[CreditWalletFields.creditWalletPaymentDueDayOfMonth] as int,
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Credit wallet id of the credit wallet
  final String creditWalletId;

  /// Wallet id of the credit wallet
  final String creditWalletWalletId;

  /// Credit limit of the credit wallet
  /// This is the maximum amount of money that can be borrowed from the credit
  /// wallet
  final double creditWalletCreditLimit;

  /// Number of days after the statement date of the credit wallet
  /// when the payment is due
  final int creditWalletStateDayOfMonth;

  /// Payment due day of month of the credit wallet
  /// This is the day of the month when the payment is due
  final int creditWalletPaymentDueDayOfMonth;

  /// Returns a copy of the [CreditWallet] with the given fields replaced.
  CreditWallet copyWith({
    String? creditWalletId,
    String? creditWalletWalletId,
    double? creditWalletCreditLimit,
    int? creditWalletStateDayOfMonth,
    int? creditWalletPaymentDueDayOfMonth,
  }) {
    return CreditWallet(
      creditWalletId: creditWalletId ?? this.creditWalletId,
      creditWalletWalletId: creditWalletWalletId ?? this.creditWalletWalletId,
      creditWalletCreditLimit:
          creditWalletCreditLimit ?? this.creditWalletCreditLimit,
      creditWalletStateDayOfMonth:
          creditWalletStateDayOfMonth ?? this.creditWalletStateDayOfMonth,
      creditWalletPaymentDueDayOfMonth:
          creditWalletPaymentDueDayOfMonth ??
          this.creditWalletPaymentDueDayOfMonth,
    );
  }
}
