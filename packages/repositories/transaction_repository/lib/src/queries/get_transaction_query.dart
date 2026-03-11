import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:shared_models/shared_models.dart';

/// {@template get_transaction_query}
/// A query to get transactions.
/// {@endtemplate}
class GetTransactionQuery extends BaseGetQuery {
  /// {@macro get_transaction_query}
  const GetTransactionQuery({
    this.walletId,
    this.categoryId,
    this.transactionType,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.transactionNotes,
    super.orderBy = TransactionFields.transactionCreatedAt,
    super.orderType,
    super.pageIndex,
    super.pageSize,
  });

  /// Filter by wallet ID
  final String? walletId;

  /// Filter by category ID
  final String? categoryId;

  /// Filter by transaction type (income/expense)
  final TransactionTypeEnum? transactionType;

  /// Filter transactions after this date
  final DateTime? startDate;

  /// Filter transactions before this date
  final DateTime? endDate;

  /// Filter transactions with amount >= this value
  final double? minAmount;

  /// Filter transactions with amount <= this value
  final double? maxAmount;

  /// Search transactions by notes
  final String? transactionNotes;

  @override
  List<Object?> get props => [
        ...super.props,
        walletId,
        categoryId,
        transactionType,
        startDate,
        endDate,
        minAmount,
        maxAmount,
        transactionNotes,
      ];
}

/// {@template custom_order_by_fields}
/// Custom order by fields
/// {@endtemplate}
class CustomOrderByFields {
  /// Absolute transaction amount
  static const absTransactionAmount = 'abs(transaction_amount)';
}
