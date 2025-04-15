import 'package:felicash_data_client/src/models/budget.dart';
import 'package:felicash_data_client/src/models/transaction.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_tracking.g.dart';

/// {@template wallet_fields}
/// Budget tracking fields.
/// {@endtemplate}
typedef BudgetTrackingFields = _$BudgetTrackingJsonKeys;

/// {@template budget_tracking}
/// Model for budget tracking entries.
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class BudgetTracking {
  /// {@macro budget_tracking}
  const BudgetTracking({
    required this.budgetTrackingId,
    required this.budgetTrackingAmount,
    required this.budgetTrackingCreatedAt,
    required this.budgetTrackingUpdatedAt,
    required this.budgetTrackingTransactionId,
    required this.budgetTrackingBudgetId,
    this.transactions = const [],
    this.budgets = const [],
  }) : id = budgetTrackingId;

  /// Factory constructor for creating a [BudgetTracking] from a [SqliteRow].
  factory BudgetTracking.fromRow(SqliteRow row) {
    return BudgetTracking(
      budgetTrackingId: row[BudgetTrackingFields.budgetTrackingId] as String,
      budgetTrackingAmount:
          row[BudgetTrackingFields.budgetTrackingAmount] as double,
      budgetTrackingCreatedAt: DateTime.parse(
        row[BudgetTrackingFields.budgetTrackingCreatedAt] as String,
      ),
      budgetTrackingUpdatedAt: DateTime.parse(
        row[BudgetTrackingFields.budgetTrackingUpdatedAt] as String,
      ),
      budgetTrackingTransactionId:
          row[BudgetTrackingFields.budgetTrackingTransactionId] as String,
      budgetTrackingBudgetId:
          row[BudgetTrackingFields.budgetTrackingBudgetId] as String,
      transactions: [],
      budgets: [],
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the budget tracking entry
  final String budgetTrackingId;

  /// Amount of the budget tracking entry
  final double budgetTrackingAmount;

  /// Timestamp when the budget tracking entry was created
  final DateTime budgetTrackingCreatedAt;

  /// Timestamp when the budget tracking entry was last updated
  final DateTime budgetTrackingUpdatedAt;

  /// Transaction id of the budget tracking entry
  final String budgetTrackingTransactionId;

  /// List of transactions of the budget tracking entry
  final List<Transaction> transactions;

  /// Budget id of the budget tracking entry
  final String budgetTrackingBudgetId;

  /// List of budgets of the budget tracking entry
  final List<Budget> budgets;

  /// Returns a copy of the [BudgetTracking] with the given fields replaced.
  BudgetTracking copyWith({
    String? budgetTrackingId,
    double? budgetTrackingAmount,
    DateTime? budgetTrackingCreatedAt,
    DateTime? budgetTrackingUpdatedAt,
    String? budgetTrackingTransactionId,
    List<Transaction>? transactions,
    String? budgetTrackingBudgetId,
    List<Budget>? budgets,
  }) {
    return BudgetTracking(
      budgetTrackingId: budgetTrackingId ?? this.budgetTrackingId,
      budgetTrackingAmount: budgetTrackingAmount ?? this.budgetTrackingAmount,
      budgetTrackingCreatedAt:
          budgetTrackingCreatedAt ?? this.budgetTrackingCreatedAt,
      budgetTrackingUpdatedAt:
          budgetTrackingUpdatedAt ?? this.budgetTrackingUpdatedAt,
      budgetTrackingTransactionId:
          budgetTrackingTransactionId ?? this.budgetTrackingTransactionId,
      transactions: transactions ?? this.transactions,
      budgetTrackingBudgetId:
          budgetTrackingBudgetId ?? this.budgetTrackingBudgetId,
      budgets: budgets ?? this.budgets,
    );
  }
}
