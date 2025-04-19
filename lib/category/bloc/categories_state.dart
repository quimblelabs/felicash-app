part of 'categories_bloc.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading({
    this.categories = const [],
  });

  final List<CategoryModel> categories;

  @override
  List<Object> get props => [categories];
}

final class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({required this.categories});

  final List<CategoryModel> categories;

  @override
  List<Object> get props => [categories];
}

final class CategoriesFailure extends CategoriesState {
  const CategoriesFailure(this.error, this.previousQuery);

  final Object error;
  final GetCategoryQuery previousQuery;

  @override
  List<Object> get props => [error, previousQuery];
}
