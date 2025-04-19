import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/category/cubit/category_select_state.dart';

class CategorySelectCubit extends Cubit<CategorySelectState> {
  CategorySelectCubit()
      : super(
          const CategorySelectInitial(),
        );

  void selectCategory(CategoryModel category) {
    emit(CategorySelectSelected(selectedCategory: category));
  }
}
