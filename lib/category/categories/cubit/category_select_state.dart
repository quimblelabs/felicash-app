import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';

sealed class CategorySelectState extends Equatable {
  const CategorySelectState({
    this.selectedCategory,
  });

  final CategoryModel? selectedCategory;

  @override
  List<Object?> get props => [
        selectedCategory,
      ];
}

final class CategorySelectInitial extends CategorySelectState {
  const CategorySelectInitial({
    super.selectedCategory,
  });
}

final class CategorySelectSelected extends CategorySelectState {
  const CategorySelectSelected({
    required super.selectedCategory,
  });
}
