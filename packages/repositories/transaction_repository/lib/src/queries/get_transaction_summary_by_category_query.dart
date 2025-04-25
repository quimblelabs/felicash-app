import 'package:shared_models/shared_models.dart';

/// {@template get_transaction_summary_by_category_query}
/// A query to get the transaction summary by category.
/// {@endtemplate}
class GetTransactionSummaryByCategoryQuery {
  /// {@macro get_transaction_summary_by_category_query}
  const GetTransactionSummaryByCategoryQuery({
    required this.convertToCurrencyId,
    required this.transactionType,
    this.startDate,
    this.endDate,
  });

  /// The id of the currency to convert to.
  final String convertToCurrencyId;

  /// The type of the transaction.
  final TransactionTypeEnum? transactionType;

  /// The start date of the query.
  final DateTime? startDate;

  /// The end date of the query.
  final DateTime? endDate;
}
