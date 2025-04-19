import 'package:equatable/equatable.dart';

class DailySummary extends Equatable {
  const DailySummary({
    required this.date,
    required this.expense,
    required this.income,
  });

  final DateTime date;
  final double expense;
  final double income;
  @override
  List<Object?> get props => [date, expense, income];
}
