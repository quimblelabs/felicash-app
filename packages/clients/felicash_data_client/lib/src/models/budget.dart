import 'package:felicash_data_client/felicash_data_client.dart' show SqliteRow;
import 'package:felicash_data_client/src/enums/budget_period.dart';
import 'package:felicash_data_client/src/models/budget_tracking.dart';
import 'package:felicash_data_client/src/models/category.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart' show SqliteRow;
import 'package:json_annotation/json_annotation.dart';

part 'budget.g.dart';

/// {@template wallet_fields}
/// Budget fields.
/// {@endtemplate}
typedef BudgetFields = _$BudgetJsonKeys;

/// {@template budget_tracking}
/// Model for budget entries.
/// {@endtemplate}
// ignore: must_be_immutable
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
/// {@template budget_model}
/// Budget model
/// {@endtemplate}
class Budget {
  /// {@macro budget_model}
  const Budget({
    required this.budgetId,
    required this.budgetUserId,
    required this.budgetBudgetPeriod,
    required this.budgetAmount,
    required this.budgetStartDate,
    required this.budgetEndDate,
    required this.budgetCreatedAt,
    required this.budgetUpdatedAt,
    required this.budgetCategoryId,
    this.categories = const [],
    this.budgetTrackings = const [],
  }) : id = budgetId;

  /// Factory constructor for creating a [Budget] from a [SqliteRow].
  factory Budget.fromRow(SqliteRow row) {
    return Budget(
      budgetId: row[BudgetFields.budgetId] as String,
      budgetUserId: row[BudgetFields.budgetUserId] as String,
      budgetBudgetPeriod: BudgetPeriod.values.byName(
        row[BudgetFields.budgetBudgetPeriod] as String,
      ),
      budgetAmount: row[BudgetFields.budgetAmount] as double,
      budgetStartDate: DateTime.parse(
        row[BudgetFields.budgetStartDate] as String,
      ),
      budgetEndDate: DateTime.parse(row[BudgetFields.budgetEndDate] as String),
      budgetCreatedAt: DateTime.parse(
        row[BudgetFields.budgetCreatedAt] as String,
      ),
      budgetUpdatedAt: DateTime.parse(
        row[BudgetFields.budgetUpdatedAt] as String,
      ),
      budgetCategoryId: row[BudgetFields.budgetCategoryId] as String,
      categories: [],
      budgetTrackings: [],
    );
  }

  /// Table name of the budget
  static const String tableName = 'budgets';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the budget
  final String budgetId;

  /// Profile id of the budget
  final String budgetUserId;

  /// Period of the budget
  final BudgetPeriod budgetBudgetPeriod;

  /// Amount of the budget
  final double budgetAmount;

  /// Start date of the budget
  final DateTime budgetStartDate;

  /// End date of the budget
  final DateTime budgetEndDate;

  /// Created at of the budget
  final DateTime budgetCreatedAt;

  /// Updated at of the budget
  final DateTime budgetUpdatedAt;

  /// Budget trackings of the budget
  final List<BudgetTracking> budgetTrackings;

  /// Category id of the budget
  final String budgetCategoryId;

  /// Category of the budget
  final List<Category> categories;

  /// Returns a copy of the [Budget] with the given fields replaced.
  Budget copyWith({
    String? budgetId,
    String? budgetUserId,
    BudgetPeriod? budgetBudgetPeriod,
    double? budgetAmount,
    DateTime? budgetStartDate,
    DateTime? budgetEndDate,
    DateTime? budgetCreatedAt,
    DateTime? budgetUpdatedAt,
    List<BudgetTracking>? budgetTrackings,
    String? budgetCategoryId,
    List<Category>? categories,
  }) {
    return Budget(
      budgetId: budgetId ?? this.budgetId,
      budgetUserId: budgetUserId ?? this.budgetUserId,
      budgetBudgetPeriod: budgetBudgetPeriod ?? this.budgetBudgetPeriod,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      budgetStartDate: budgetStartDate ?? this.budgetStartDate,
      budgetEndDate: budgetEndDate ?? this.budgetEndDate,
      budgetCreatedAt: budgetCreatedAt ?? this.budgetCreatedAt,
      budgetUpdatedAt: budgetUpdatedAt ?? this.budgetUpdatedAt,
      budgetTrackings: budgetTrackings ?? this.budgetTrackings,
      budgetCategoryId: budgetCategoryId ?? this.budgetCategoryId,
      categories: categories ?? this.categories,
    );
  }
}
