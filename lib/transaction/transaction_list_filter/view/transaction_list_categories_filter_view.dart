import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/category/categories/bloc/categories_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class TransactionListCategoriesFilterView extends StatefulWidget {
  const TransactionListCategoriesFilterView({
    required this.initialSelected,
    super.key,
  });

  final Set<CategoryModel> initialSelected;

  @override
  State<TransactionListCategoriesFilterView> createState() =>
      _TransactionListCategoriesFilterViewState();
}

class _TransactionListCategoriesFilterViewState
    extends State<TransactionListCategoriesFilterView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late Set<CategoryModel> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = {...widget.initialSelected};
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  void _onCategorySelected(CategoryModel category, bool? value) {
    setState(() {
      final isSelected = value ?? false;
      final newSelectedCategories =
          Set<CategoryModel>.from(_selectedCategories);
      if (!isSelected) {
        newSelectedCategories.remove(category);
      } else {
        newSelectedCategories.add(category);
      }
      _selectedCategories = newSelectedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final categoriesState = context.select<CategoriesBloc, CategoriesState>(
      (value) => value.state,
    );

    if (categoriesState is CategoriesLoadFailure) {
      return Center(
        child: Text(
          l10n.transactionListCategoriesFilterViewFailedToFetchCategoriesErrorMessage,
        ),
      );
    }

    if (categoriesState is CategoriesLoadInProgress ||
        categoriesState is CategoriesInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final categories = (categoriesState as CategoriesLoadSuccess)
        .categories
        .where(
          (category) =>
              category.name.toLowerCase().contains(_searchText.toLowerCase()),
        )
        .toList();
    final canSelectAll =
        categories.isNotEmpty && _selectedCategories.length < categories.length;
    final canDeselectAll =
        categories.isNotEmpty && _selectedCategories.isNotEmpty;
    return SheetContentScaffold(
      topBar: AppBar(
        title: Text(l10n.transactionListCategoriesFilterViewTitle),
      ),
      body: Material(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategorySearchField(controller: _searchController),
              const SizedBox(height: AppSpacing.md),
              _SelectionsToggle(
                selectedCategories: _selectedCategories,
                onSelectedAll: canSelectAll
                    ? () {
                        setState(() {
                          _selectedCategories =
                              Set<CategoryModel>.from(categories);
                        });
                      }
                    : null,
                onDeselectedAll: canDeselectAll
                    ? () {
                        setState(() {
                          _selectedCategories = {};
                        });
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: _CategoryList(
                  categories: categories,
                  selectedCategories: _selectedCategories,
                  onCategorySelected: _onCategorySelected,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SubmitButton(
                selectedCategories: _selectedCategories,
                initialSelected: widget.initialSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _SelectionsToggle extends StatelessWidget {
  const _SelectionsToggle({
    required this.selectedCategories,
    required this.onSelectedAll,
    required this.onDeselectedAll,
  });

  final Set<CategoryModel> selectedCategories;
  final VoidCallback? onSelectedAll;
  final VoidCallback? onDeselectedAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        TextButton(
          onPressed: onSelectedAll,
          child: Text(l10n.selectAll),
        ),
        TextButton(
          onPressed: onDeselectedAll,
          child: Text(l10n.deselectAll),
        ),
      ],
    );
  }
}

class _CategorySearchField extends StatelessWidget {
  const _CategorySearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText:
            l10n.transactionListCategoriesFilterViewSearchCategoriesHintText,
        isDense: true,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.selectedCategories,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final Set<CategoryModel> selectedCategories;
  // ignore: avoid_positional_boolean_parameters
  final void Function(CategoryModel, bool?) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    if (categories.isEmpty) {
      return Center(
        child: Text(
          l10n.transactionListCategoriesFilterViewNoCategoriesFoundErrorMessage,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryItem(
          category: category,
          isSelected: selectedCategories.contains(category),
          onSelected: (value) => onCategorySelected(category, value),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  final CategoryModel category;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      value: isSelected,
      onChanged: onSelected,
      title: Text(category.name),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: IconWidget(icon: category.icon),
    );
  }
}

class _SubmitButton extends HookWidget {
  const _SubmitButton({
    required this.selectedCategories,
    required this.initialSelected,
  });

  final Set<CategoryModel> selectedCategories;
  final Set<CategoryModel> initialSelected;

  bool _hasChanges() {
    return !initialSelected.isSameOfAll(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasChanges = _hasChanges();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: hasChanges ? 1.0 : 0.0,
    );

    useEffect(
      () {
        if (hasChanges) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        return null;
      },
      [hasChanges],
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: Text(
                l10n.transactionListCategoriesFilterViewCancelButtonLabel,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: hasChanges ? 1 : 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                width: hasChanges ? null : 0,
                child: SlideTransition(
                  position: slideAnimation,
                  child: FilledButton(
                    onPressed: () => context.pop(selectedCategories),
                    child: Text(
                      '${l10n.update} (${selectedCategories.length})',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Set<CategoryModel> {
  /// Returns true if the set contains all the elements of the other
  /// set and vice vers, also length must be the same.
  bool isSameOfAll(Set<CategoryModel> other) {
    if (length != other.length) {
      return false;
    }
    if (isEmpty) {
      return other.isEmpty;
    }
    return other.every(contains) && every(other.contains);
  }
}
