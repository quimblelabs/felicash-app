part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CategoriesSubscriptionRequested extends CategoriesEvent {
  const CategoriesSubscriptionRequested({
    required this.query,
  });

  final GetCategoryQuery query;

  @override
  List<Object> get props => [query];
}

class CategoriesSubcriptionRetry extends CategoriesEvent {
  const CategoriesSubcriptionRetry({
    required this.query,
  });

  final GetCategoryQuery query;

  @override
  List<Object> get props => [query];
}
