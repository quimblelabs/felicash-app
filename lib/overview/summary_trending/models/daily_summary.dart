import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

class DailySummary extends Equatable {
  const DailySummary({
    required this.date,
    required this.expense,
    required this.income,
  });

  final DateTime date;
  final double expense;
  final double income;

  DailySummary copyWith({
    DateTime? date,
    double? expense,
    double? income,
  }) {
    return DailySummary(
      date: date ?? this.date,
      expense: expense ?? this.expense,
      income: income ?? this.income,
    );
  }

  @override
  List<Object?> get props => [date, expense, income];
}

extension DailySummaryListX on List<DailySummary> {
  /// Creates a list of daily summaries from a list of transaction summary by
  /// transaction date models.
  static List<DailySummary> fromTransactionSummaryByTransactionDateModels(
    List<TransactionSummaryByTransactionDateModel> models,
  ) {
    return models.map((model) {
      return DailySummary(
        date: model.transactionDate,
        expense: model.totalExpenseExchanged,
        income: model.totalIncomeExchanged,
      );
    }).toList();
  }
}
