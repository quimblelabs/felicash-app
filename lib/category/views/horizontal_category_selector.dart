import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/category/bloc/categories_bloc.dart';
import 'package:felicash/category/cubit/category_select_cubit.dart';
import 'package:felicash/category/cubit/category_select_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalCategorySelector extends StatelessWidget {
  const HorizontalCategorySelector({
    super.key,
    this.initialCategory,
    this.onCategorySelected,
  });

  final CategoryModel? initialCategory;
  final ValueChanged<CategoryModel?>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategorySelectCubit>(
      create: (context) {
        final cubit = CategorySelectCubit();
        if (initialCategory != null) {
          cubit.selectCategory(initialCategory!);
        }
        return cubit;
      },
      child: BlocListener<CategorySelectCubit, CategorySelectState>(
        listener: (context, state) {
          if (state is CategorySelectSelected) {
            onCategorySelected?.call(state.selectedCategory);
          }
        },
        child: const HorizontalCategorySelectionView(),
      ),
    );
  }
}

class HorizontalCategorySelectionView extends StatelessWidget {
  const HorizontalCategorySelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesBloc = context.read<CategoriesBloc>();
    final state =
        context.select<CategoriesBloc, CategoriesState>((bloc) => bloc.state);
    return switch (state) {
      CategoriesInitial() || CategoriesLoadInProgress() => const SizedBox(
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      CategoriesLoadSuccess(:final categories) => _CategorySelections(
          categories: categories,
        ),
      CategoriesLoadFailure(
        :final messageText,
        :final previousQuery,
      ) =>
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                messageText,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              IconButton(
                onPressed: () {
                  categoriesBloc.add(
                    CategoriesSubcriptionRetry(
                      query: previousQuery,
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
    };
  }
}

class _CategorySelections extends StatelessWidget {
  const _CategorySelections({
    required this.categories,
  });

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCategory =
        context.select<CategorySelectCubit, CategoryModel?>(
      (cubit) => cubit.state.selectedCategory,
    );
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        ...categories.map(
          (category) => ChoiceChip(
            selected: selectedCategory == category,
            onSelected: (_) {
              context.read<CategorySelectCubit>().selectCategory(category);
            },
            avatar: IconWidget(
              icon: category.icon,
              color: theme.colorScheme.onSurface,
            ),
            labelStyle: theme.textTheme.labelLarge,
            label: Text(category.name.hardCoded),
          ),
        ),
      ],
    );
  }
}
