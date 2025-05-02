part of 'categories_bloc.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoadInProgress extends CategoriesState {
  const CategoriesLoadInProgress({
    this.messageText = 'Loading categories...',
  });

  /// The message text to be displayed when the categories are loading.
  final String messageText;

  @override
  List<Object> get props => [messageText];
}

final class CategoriesLoadSuccess extends CategoriesState {
  const CategoriesLoadSuccess({required this.categories});

  final List<CategoryModel> categories;

  @override
  List<Object> get props => [categories];
}

final class CategoriesLoadFailure extends CategoriesState {
  const CategoriesLoadFailure({
    required this.error,
    required this.previousQuery,
    this.messageText = 'Error when load categories',
  });

  final String messageText;
  final Object error;
  final GetCategoryQuery previousQuery;

  @override
  List<Object> get props => [error, previousQuery];
}
