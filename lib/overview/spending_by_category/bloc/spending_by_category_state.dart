part of 'spending_by_category_bloc.dart';

enum SpendingByCategoryStatus { initial, loading, success, failure }

class SpendingByCategoryState extends Equatable {
  const SpendingByCategoryState({
    this.categorySpendingStats = const [],
    this.status = SpendingByCategoryStatus.initial,
    this.selectedCategorySpendingStat,
  });

  final List<CategorySpendingStat> categorySpendingStats;
  final SpendingByCategoryStatus status;
  final CategorySpendingStat? selectedCategorySpendingStat;

  SpendingByCategoryState setSelectedCategorySpendingStat(
    CategorySpendingStat? stat,
  ) {
    return SpendingByCategoryState(
      categorySpendingStats: categorySpendingStats,
      status: status,
      selectedCategorySpendingStat: stat,
    );
  }

  SpendingByCategoryState copyWith({
    List<CategorySpendingStat>? categorySpendingStats,
    SpendingByCategoryStatus? status,
    CategorySpendingStat? selectedCategorySpendingStat,
  }) {
    return SpendingByCategoryState(
      categorySpendingStats:
          categorySpendingStats ?? this.categorySpendingStats,
      status: status ?? this.status,
      selectedCategorySpendingStat:
          selectedCategorySpendingStat ?? this.selectedCategorySpendingStat,
    );
  }

  @override
  List<Object?> get props => [
        categorySpendingStats,
        status,
        selectedCategorySpendingStat,
      ];
}
