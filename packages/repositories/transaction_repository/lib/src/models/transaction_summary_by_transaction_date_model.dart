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
    required this.incomeCount,
    required this.expenseCount,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalIncomeExchanged,
    required this.totalExpenseExchanged,
    required this.baseCurrencyCode,
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
      incomeCount:
          row[TransactionSummaryByTransactionDateModelFields.incomeCount]
              as int,
      expenseCount:
          row[TransactionSummaryByTransactionDateModelFields.expenseCount]
              as int,
      totalIncome:
          row[TransactionSummaryByTransactionDateModelFields.totalIncome]
              as double,
      totalExpense:
          row[TransactionSummaryByTransactionDateModelFields.totalExpense]
              as double,
      totalIncomeExchanged: row[TransactionSummaryByTransactionDateModelFields
          .totalIncomeExchanged] as double,
      totalExpenseExchanged: row[TransactionSummaryByTransactionDateModelFields
          .totalExpenseExchanged] as double,
      baseCurrencyCode:
          row[TransactionSummaryByTransactionDateModelFields.baseCurrencyCode]
              as String,
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

  /// The number of income transactions.
  final int incomeCount;

  /// The number of expense transactions.
  final int expenseCount;

  /// The total amount of income transactions.
  final double totalIncome;

  /// The total amount of expense transactions.
  final double totalExpense;

  /// The total amount of income transactions in the exchange currency.
  final double totalIncomeExchanged;

  /// The total amount of expense transactions in the exchange currency.
  final double totalExpenseExchanged;

  /// The base currency code of the transactions.
  final String baseCurrencyCode;

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
    incomeCount: 0,
    expenseCount: 0,
    totalIncome: 0,
    totalExpense: 0,
    totalIncomeExchanged: 0,
    totalExpenseExchanged: 0,
    baseCurrencyCode: '',
    exchangeCurrencyCode: '',
    exchangeRateRate: 0,
    exchangeRateEffectiveDate: DateTime(1),
  );
}
