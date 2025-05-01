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
    final summaries = <DateTime, DailySummary>{};
    for (final model in models) {
      final date = model.transactionDate;
      if (summaries.containsKey(date)) {
        summaries[date] = summaries[date]!.copyWith(
          expense: summaries[date]!.expense + model.totalAmount,
          income: summaries[date]!.income + model.totalAmountExchanged,
        );
      } else {
        summaries[date] = DailySummary(
          date: date,
          expense: model.totalAmount,
          income: model.totalAmountExchanged,
        );
      }
    }
    return summaries.values.toList();
  }
}
