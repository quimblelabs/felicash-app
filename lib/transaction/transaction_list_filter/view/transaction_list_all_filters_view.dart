import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/transaction/bloc/transaction_list_filter_cubit.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:wallet_repository/wallet_repository.dart';

typedef _TxDateRange = ({DateTime? from, DateTime? to});

class AllFiltersView extends StatelessWidget {
  const AllFiltersView({
    required this.initialFilter,
    super.key,
  });

  final TransactionListFilter initialFilter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionListFilterCubit(
        initialFilter: initialFilter,
      ),
      child: const _AllFiltersView(),
    );
  }
}

class _AllFiltersView extends StatelessWidget {
  const _AllFiltersView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        badgeTheme: theme.badgeTheme.copyWith(
          backgroundColor: theme.colorScheme.primary,
          textStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
        ),
      ),
      child: SheetContentScaffold(
        topBar: AppBar(
          title: Text('Transaction Filters'.hardCoded),
          automaticallyImplyLeading: false,
          actions: const [ModalCloseButton()],
        ),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Material(
            color: theme.colorScheme.surface,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoriesFilter(),
                _WalletsFilter(),
                _TypesFilter(),
                _TransactionDateFilter(),
                SizedBox(height: AppSpacing.lg),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoriesFilter extends StatelessWidget {
  const _CategoriesFilter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
        Set<CategoryModel>>(
      selector: (state) => state.filter.categories,
      builder: (context, categories) {
        return ListTile(
          onTap: () async {
            final result = await context.pushNamed<Set<CategoryModel>?>(
              AppRouteNames.transactionListFilterCategories,
              extra: categories,
            );
            if (context.mounted) {
              if (result != null) {
                context
                    .read<TransactionListFilterCubit>()
                    .updateCategories(result);
              }
            }
          },
          title: Text('Categories'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: categories.isNotEmpty,
                label: Text(categories.length.toString()),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
    );
  }
}

class _WalletsFilter extends StatelessWidget {
  const _WalletsFilter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
        Set<BaseWalletModel>>(
      selector: (state) => state.filter.wallets,
      builder: (context, wallets) {
        return ListTile(
          onTap: () async {
            final result = await context.pushNamed<Set<BaseWalletModel>?>(
              AppRouteNames.transactionListFilterWallets,
              extra: wallets,
            );
            if (context.mounted) {
              if (result != null) {
                context
                    .read<TransactionListFilterCubit>()
                    .updateWallets(result);
              }
            }
          },
          title: Text('Wallets'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: wallets.isNotEmpty,
                label: Text(wallets.length.toString()),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
    );
  }
}

class _TypesFilter extends StatelessWidget {
  const _TypesFilter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
        Set<TransactionTypeEnum>>(
      selector: (state) => state.filter.types,
      builder: (context, types) {
        return ListTile(
          onTap: () async {
            final result = await context.pushNamed<Set<TransactionTypeEnum>?>(
              AppRouteNames.transactionListFilterTypes,
              extra: types,
            );
            if (context.mounted) {
              if (result != null) {
                context.read<TransactionListFilterCubit>().updateTypes(result);
              }
            }
          },
          title: Text('Transaction Types'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: types.isNotEmpty,
                label: Text(types.length.toString()),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
    );
  }
}

class _TransactionDateFilter extends StatelessWidget {
  const _TransactionDateFilter();

  String? _getLabel(DateTime? from, DateTime? to, [String? locale]) {
    if (from == null && to == null) return null;

    if (from != null && to != null) {
      final fromDate = from;
      final toDate = to;

      // Check if it's a single day
      if (fromDate.isAtSameMomentAs(toDate)) {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));

        if (fromDate.year == now.year &&
            fromDate.month == now.month &&
            fromDate.day == now.day) {
          return 'Today';
        } else if (fromDate.year == yesterday.year &&
            fromDate.month == yesterday.month &&
            fromDate.day == yesterday.day) {
          return 'Yesterday';
        } else {
          return fromDate.toLocal().yMMMd(locale);
        }
      }

      // Check if it's a week (7 days starting from Monday)
      final difference = toDate.difference(fromDate).inDays;
      if (difference == 6 && fromDate.weekday == 1) {
        return '${fromDate.toLocal().yMMMd(locale)} - ${toDate.toLocal().yMMMd(locale)}';
      }

      // Check if it's a month
      if (fromDate.day == 1 &&
          toDate.day == DateTime(toDate.year, toDate.month + 1, 0).day) {
        return fromDate.toLocal().yMMM(locale);
      }

      // Custom range
      return '${fromDate.toLocal().yMMMd(locale)} - ${toDate.toLocal().yMMMd(locale)}';
    } else if (from != null) {
      return 'From ${from.toLocal().yMMMd(locale)}'.hardCoded;
    } else if (to != null) {
      return 'To ${to.toLocal().yMMMd(locale)}'.hardCoded;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
        _TxDateRange>(
      selector: (state) => (from: state.filter.from, to: state.filter.to),
      builder: (context, range) {
        final locale = Localizations.localeOf(context).toString();
        final label = _getLabel(range.from, range.to, locale);

        return ListTile(
          onTap: () async {
            final result = await context.pushNamed<(DateTime?, DateTime?)?>(
              AppRouteNames.transactionListFilterDate,
              extra: (range.from, range.to),
            );
            if (context.mounted) {
              if (result != null) {
                final cubit = context.read<TransactionListFilterCubit>();
                if (result.$1 != null) {
                  cubit.updateFrom(result.$1!);
                }
                if (result.$2 != null) {
                  cubit.updateTo(result.$2!);
                }
              }
            }
          },
          title: Text('Transaction Date'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Badge(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: Text(label),
                  ),
                ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final initialFilter =
        context.read<TransactionListFilterCubit>().state.initialFilter;
    final currentFilter =
        context.select<TransactionListFilterCubit, TransactionListFilter>(
      (value) => value.state.filter,
    );

    final isInitial = currentFilter == initialFilter;

    return FilledButton(
      onPressed: () {
        if (isInitial) {
          context.pop();
        } else {
          final currentFilter =
              context.read<TransactionListFilterCubit>().state.filter;
          context.pop(currentFilter);
        }
      },
      child: Text('Apply'.hardCoded),
    );
  }
}
