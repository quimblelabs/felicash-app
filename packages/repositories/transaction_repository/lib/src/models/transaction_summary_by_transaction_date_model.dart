import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_summary_by_transaction_date_model.g.dart';

/// {@template transaction_summary_by_transaction_date_model_fields}
/// The fields of the transaction summary by transaction date model.
/// {@endtemplate}
typedef TransactionSummaryByTransactionDateModelFields
    = _$TransactionSummaryByTransactionDateModelJsonKeys;

/// {@template transaction_summary_by_transaction_date_model}
/// A model that represents a summary of transactions by transaction date.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class TransactionSummaryByTransactionDateModel {
  /// {@macro transaction_summary_by_transaction_date_model}
  const TransactionSummaryByTransactionDateModel({
    required this.transactionDate,
    required this.transactionCount,
    required this.totalAmount,
    required this.baseCurrencyCode,
    required this.totalAmountExchanged,
    required this.exchangeCurrencyCode,
    required this.exchangeRateRate,
    required this.exchangeRateEffectiveDate,
  });

  /// {@macro transaction_summary_by_transaction_date_model}
  factory TransactionSummaryByTransactionDateModel.fromRow(SqliteRow row) {
    return TransactionSummaryByTransactionDateModel(
      transactionDate: DateTime.parse(
        row[TransactionSummaryByTransactionDateModelFields.transactionDate]
            as String,
      ),
      transactionCount:
          row[TransactionSummaryByTransactionDateModelFields.transactionCount]
              as int,
      totalAmount:
          row[TransactionSummaryByTransactionDateModelFields.totalAmount]
              as double,
      baseCurrencyCode:
          row[TransactionSummaryByTransactionDateModelFields.baseCurrencyCode]
              as String,
      totalAmountExchanged: row[TransactionSummaryByTransactionDateModelFields
          .totalAmountExchanged] as double,
      exchangeCurrencyCode: row[TransactionSummaryByTransactionDateModelFields
          .exchangeCurrencyCode] as String,
      exchangeRateRate:
          row[TransactionSummaryByTransactionDateModelFields.exchangeRateRate]
              as double,
      exchangeRateEffectiveDate: DateTime.parse(
        row[TransactionSummaryByTransactionDateModelFields
            .exchangeRateEffectiveDate] as String,
      ),
    );
  }

  /// The date of the transaction.
  final DateTime transactionDate;

  /// The number of transactions.
  final int transactionCount;

  /// The total amount of the transactions.
  final double totalAmount;

  /// The base currency code of the transactions.
  final String baseCurrencyCode;

  /// The total amount of the transactions in the exchange currency.
  final double totalAmountExchanged;

  /// The exchange currency code of the transactions.
  final String exchangeCurrencyCode;

  /// The exchange rate rate of the transactions.
  final double exchangeRateRate;

  /// The effective date of the exchange rate.
  final DateTime exchangeRateEffectiveDate;

  /// The empty transaction summary by transaction date model.
  static TransactionSummaryByTransactionDateModel empty =
      TransactionSummaryByTransactionDateModel(
    transactionDate: DateTime(1),
    transactionCount: 0,
    totalAmount: 0,
    baseCurrencyCode: '',
    totalAmountExchanged: 0,
    exchangeCurrencyCode: '',
    exchangeRateRate: 0,
    exchangeRateEffectiveDate: DateTime(1),
  );
}
