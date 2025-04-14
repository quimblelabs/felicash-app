import 'package:felicash_data_client/felicash_data_client.dart' show SqliteRow;
import 'package:felicash_data_client/src/models/profile.dart';
import 'package:felicash_data_client/src/models/transaction.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart' show SqliteRow;
import 'package:json_annotation/json_annotation.dart';
part 'lending_borrowing_transaction.g.dart';

/// {@template lending_borrowing_transaction_model}
/// Model for lending borrowing transaction.
/// {@endtemplate}
typedef LendingBorrowingTransactionFields =
    _$LendingBorrowingTransactionJsonKeys;

/// {@template exchange_rate_model}
/// Model for exchange rate.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class LendingBorrowingTransaction {
  /// {@macro lending_borrowing_transaction_model}
  const LendingBorrowingTransaction({
    required this.lendingBorrowingTransactionId,
    required this.lendingBorrowingTransactionTransactionId,
    required this.lendingBorrowingTransactionPaybackAmount,
    this.lendingBorrowingTransactionCounterPartyId,
    this.lendingBorrowingTransactionCounterPartyName,
    this.transactions = const [],
    this.counterParties = const [],
  }) : id = lendingBorrowingTransactionId;

  /// Factory constructor for [LendingBorrowingTransaction] from [SqliteRow]
  factory LendingBorrowingTransaction.fromRow(SqliteRow row) {
    return LendingBorrowingTransaction(
      lendingBorrowingTransactionId:
          row[LendingBorrowingTransactionFields.lendingBorrowingTransactionId]
              as String,
      lendingBorrowingTransactionTransactionId:
          row[LendingBorrowingTransactionFields
                  .lendingBorrowingTransactionTransactionId]
              as String,
      lendingBorrowingTransactionPaybackAmount:
          row[LendingBorrowingTransactionFields
                  .lendingBorrowingTransactionPaybackAmount]
              as double,
      lendingBorrowingTransactionCounterPartyId:
          row[LendingBorrowingTransactionFields
                  .lendingBorrowingTransactionCounterPartyId]
              as String?,
      lendingBorrowingTransactionCounterPartyName:
          row[LendingBorrowingTransactionFields
                  .lendingBorrowingTransactionCounterPartyName]
              as String?,
      transactions: [],
      counterParties: [],
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Lending borrowing transaction id of the lending borrowing transaction
  final String lendingBorrowingTransactionId;

  /// Name of the counter party
  final String? lendingBorrowingTransactionCounterPartyName;

  /// Amount of the lending borrowing transaction
  /// This is the amount of money that is lent or borrowed
  final double lendingBorrowingTransactionPaybackAmount;

  /// Id of the lending borrowing transaction
  final String lendingBorrowingTransactionTransactionId;

  /// Transaction of the lending borrowing transaction
  final List<Transaction> transactions;

  /// Id of the counter party
  /// This is the id of the profile of the user
  /// who is lending or borrowing money
  /// from the current user
  final String? lendingBorrowingTransactionCounterPartyId;

  /// Counter party of the lending borrowing transaction
  /// This is the profile of the user who is lending or borrowing money
  /// from the current user
  final List<Profile> counterParties;

  /// Returns a copy of the [LendingBorrowingTransaction] with the given
  /// fields replaced.
  LendingBorrowingTransaction copyWith({
    String? lendingBorrowingTransactionId,
    String? lendingBorrowingTransactionTransactionId,
    double? lendingBorrowingTransactionPaybackAmount,
    String? lendingBorrowingTransactionCounterPartyId,
    String? lendingBorrowingTransactionCounterPartyName,
    List<Transaction>? transactions,
    List<Profile>? counterParties,
  }) {
    return LendingBorrowingTransaction(
      lendingBorrowingTransactionId:
          lendingBorrowingTransactionId ?? this.lendingBorrowingTransactionId,
      lendingBorrowingTransactionTransactionId:
          lendingBorrowingTransactionTransactionId ??
          this.lendingBorrowingTransactionTransactionId,
      lendingBorrowingTransactionPaybackAmount:
          lendingBorrowingTransactionPaybackAmount ??
          this.lendingBorrowingTransactionPaybackAmount,
      lendingBorrowingTransactionCounterPartyId:
          lendingBorrowingTransactionCounterPartyId ??
          this.lendingBorrowingTransactionCounterPartyId,
      lendingBorrowingTransactionCounterPartyName:
          lendingBorrowingTransactionCounterPartyName ??
          this.lendingBorrowingTransactionCounterPartyName,
      transactions: transactions ?? this.transactions,
      counterParties: counterParties ?? this.counterParties,
    );
  }
}
