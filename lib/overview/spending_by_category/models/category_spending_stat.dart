import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';

class CategorySpendingStat extends Equatable {
  const CategorySpendingStat({
    required this.category,
    required this.spending,
    required this.transactionCount,
  });

  final CategoryModel category;
  final double spending;
  final int transactionCount;

  static CategorySpendingStat empty = CategorySpendingStat(
    category: CategoryModel.empty,
    spending: 0,
    transactionCount: 0,
  );

  bool get isEmpty => this == empty;

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
