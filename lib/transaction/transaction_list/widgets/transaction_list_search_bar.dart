part of '../view/transactions_page.dart';

class TransactionListSearchBar extends StatefulWidget {
  const TransactionListSearchBar({
    super.key,
  });

  @override
  State<TransactionListSearchBar> createState() =>
      _TransactionListSearchBarState();
}

class _TransactionListSearchBarState extends State<TransactionListSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCleared = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final filterSearchKey =
        context.read<TransactionListFilterCubit>().state.filter.searchKey;
    final searchKey = _searchController.text;
    if (searchKey.isEmpty) {
      setState(() => _isCleared = true);
    } else {
      setState(() => _isCleared = false);
    }
    if (searchKey != filterSearchKey) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<TransactionListFilterCubit>().updateSearchKey(searchKey);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        style: theme.textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: 'Search transactions...'.hardCoded,
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
          prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1),
          suffixIcon: SizedBox(
            width: 20,
            height: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => Align(
                alignment: Alignment.centerRight,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
              child: _isCleared
                  ? null
                  : IconButton(
                      key: const ValueKey('clear_button'),
                      icon: const Icon(IconsaxPlusLinear.close_circle),
                      onPressed: _searchController.clear,
                    ),
            ),
          ),
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
        ),
      ),
    );
  }
}
