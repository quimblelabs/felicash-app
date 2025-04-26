import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// {@template category_spending_stat}
/// A model that represents the spending stat of a category.
/// {@endtemplate}
class CategorySpendingStat extends Equatable {
  /// {@macro category_spending_stat}
  const CategorySpendingStat({
    required this.category,
    required this.spending,
    required this.transactionCount,
  });

  /// The category of the spending stat.
  final CategoryModel category;

  /// The spending of the category.
  final double spending;

  /// The transaction count of the category.
  final int transactionCount;

  /// The empty category spending stat.
  static CategorySpendingStat empty = CategorySpendingStat(
    category: CategoryModel.empty,
    spending: 0,
    transactionCount: 0,
  );

  /// Whether the category spending stat is empty.
  bool get isEmpty => this == empty;

  /// Copy with.
  CategorySpendingStat copyWith({
    CategoryModel? category,
    double? spending,
    int? transactionCount,
  }) {
    return CategorySpendingStat(
      category: category ?? this.category,
      spending: spending ?? this.spending,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }

  @override
  List<Object?> get props => [category, spending, transactionCount];
}

extension CategorySpendingStatListX on List<CategorySpendingStat> {
  /// Creates a list of category spending stats from a list of transaction
  /// summary by category models.
  static List<CategorySpendingStat> fromTransactionSummaryByCategoryModels(
    List<TransactionSummaryByCategoryModel> transactionSummaryByCategoryModels,
  ) {
    final stats = <String, CategorySpendingStat>{};
    for (final model in transactionSummaryByCategoryModels) {
      if (stats.containsKey(model.categoryId)) {
        stats[model.categoryId] = stats[model.categoryId]!.copyWith(
          spending:
              stats[model.categoryId]!.spending + model.totalAmountExchanged,
          transactionCount: stats[model.categoryId]!.transactionCount +
              model.transactionCount,
        );
      } else {
        stats[model.categoryId] = CategorySpendingStat(
          category: CategoryModel(
            id: model.categoryId,
            transactionType: TransactionTypeEnum.expense,
            name: model.categoryName,
            icon: model.categoryIcon,
            color: model.categoryColor ?? Colors.transparent,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          spending: model.totalAmountExchanged,
          transactionCount: model.transactionCount,
        );
      }
    }
    return stats.values.toList();
  }
}
