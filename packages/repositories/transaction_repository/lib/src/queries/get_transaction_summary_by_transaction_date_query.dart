/// {@template get_transaction_summary_by_transaction_date_query}
/// A query to get the transaction summary by transaction date.
/// {@endtemplate}
class GetTransactionSummaryByTransactionDateQuery {
  /// {@macro get_transaction_summary_by_transaction_date_query}
  const GetTransactionSummaryByTransactionDateQuery({
    required this.convertToCurrencyCode,
    required this.startDate,
    required this.endDate,
  });

  /// The id of the currency to convert to.
  final String convertToCurrencyCode;

  /// The start date of the query.
  final DateTime startDate;

  /// The end date of the query.
  final DateTime endDate;
}
