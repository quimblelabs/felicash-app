import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/shared_models.dart';

part 'transaction_summary_by_category_model.g.dart';

/// {@template transaction_summary_by_category_model_fields}
/// The fields of the transaction summary by category model.
/// {@endtemplate}
typedef TransactionSummaryByCategoryModelFields
    = _$TransactionSummaryByCategoryModelJsonKeys;

/// {@template transaction_summary_by_category_model}
/// A model that represents the transaction summary by category.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class TransactionSummaryByCategoryModel {
  /// {@macro transaction_summary_by_category_model}
  const TransactionSummaryByCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.transactionCount,
    required this.totalAmount,
    required this.exchangeRateRate,
    required this.exchangeRateEffectiveDate,
    required this.baseCurrencyCode,
    required this.exchangeCurrencyCode,
    required this.totalAmountExchanged,
  });

  /// {@macro transaction_summary_by_category_model}
  factory TransactionSummaryByCategoryModel.fromRow(SqliteRow row) {
    return TransactionSummaryByCategoryModel(
      categoryId:
          row[TransactionSummaryByCategoryModelFields.categoryId] as String?,
      categoryName:
          row[TransactionSummaryByCategoryModelFields.categoryName] as String?,
      categoryIcon: RawIconData.fromRaw(
        row[TransactionSummaryByCategoryModelFields.categoryIcon] as String?,
      ),
      categoryColor: HexColor.fromHex(
        row[TransactionSummaryByCategoryModelFields.categoryColor] as String?,
      ),
      transactionCount:
          row[TransactionSummaryByCategoryModelFields.transactionCount] as int,
      totalAmount:
          row[TransactionSummaryByCategoryModelFields.totalAmount] as double,
      exchangeRateRate:
          row[TransactionSummaryByCategoryModelFields.exchangeRateRate]
              as double,
      exchangeRateEffectiveDate: DateTime.parse(
        row[TransactionSummaryByCategoryModelFields.exchangeRateEffectiveDate]
            as String,
      ),
      baseCurrencyCode:
          row[TransactionSummaryByCategoryModelFields.baseCurrencyCode]
              as String,
      exchangeCurrencyCode:
          row[TransactionSummaryByCategoryModelFields.exchangeCurrencyCode]
              as String,
      totalAmountExchanged:
          row[TransactionSummaryByCategoryModelFields.totalAmountExchanged]
              as double,
    );
  }

  /// The id of the category.
  final String? categoryId;

  /// The name of the category.
  final String? categoryName;

  /// The icon of the category.
  final RawIconData categoryIcon;

  /// The color of the category.
  final Color? categoryColor;

  /// The number of transactions in the category.
  final int transactionCount;

  /// The total amount of transactions in the category in the base currency.
  final double totalAmount;

  /// The total amount of transactions in the category in the exchange currency.
  final double totalAmountExchanged;

  /// The exchange rate rate.
  final double exchangeRateRate;

  /// The effective date of the exchange rate.
  final DateTime exchangeRateEffectiveDate;

  /// The base currency code.
  final String baseCurrencyCode;

  /// The exchange currency code.
  final String exchangeCurrencyCode;

  /// The empty transaction summary by category model.
  static TransactionSummaryByCategoryModel empty =
      TransactionSummaryByCategoryModel(
    categoryId: '',
    categoryName: '',
    categoryIcon: const ErrorDataIcon(
      raw: '',
      icon: Icons.question_mark,
      exception: FormatException('Default icon'),
    ),
    categoryColor: Colors.black,
    transactionCount: 0,
    totalAmount: 0,
    exchangeRateRate: 0,
    exchangeRateEffectiveDate: DateTime.now(),
    baseCurrencyCode: '',
    exchangeCurrencyCode: '',
    totalAmountExchanged: 0,
  );
}
