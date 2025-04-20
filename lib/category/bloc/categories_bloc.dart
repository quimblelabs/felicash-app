import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required CategoryRepository categoryRepository,
  })  : _categoryRepository = categoryRepository,
        super(CategoriesInitial()) {
    on<CategoriesSubscriptionRequested>(_onCategoriesSubscriptionRequested);
    on<CategoriesSubcriptionRetry>(_onCategoriesSubcriptionRetry);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _onCategoriesSubscriptionRequested(
    CategoriesSubscriptionRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoadInProgress());
    final categories = _categoryRepository.getCategories(event.query);
    await emit.forEach<List<CategoryModel>>(
      categories,
      onData: (categories) => CategoriesLoadSuccess(categories: categories),
      onError: (error, stackTrace) => CategoriesLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }

  Future<void> _onCategoriesSubcriptionRetry(
    CategoriesSubcriptionRetry event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoadInProgress());
    final categories = _categoryRepository.getCategories(event.query);
    await emit.forEach<List<CategoryModel>>(
      categories,
      onData: (categories) => CategoriesLoadSuccess(categories: categories),
      onError: (error, stackTrace) => CategoriesLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }
}
