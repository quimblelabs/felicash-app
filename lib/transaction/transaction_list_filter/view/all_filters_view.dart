import 'package:app_ui/app_ui.dart';
import 'package:app_utils/app_utils.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/transaction/bloc/transaction_list_filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

typedef _TxDateRange = ({DateTime? from, DateTime? to});

class AllFiltersView extends StatelessWidget {
  const AllFiltersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      children: <Widget>[
        const _CategoriesFilter(),
        const _WalletsFilter(),
        const _TypesFilter(),
        const _DateRangeFilter(),
      ]
          .joinItems(separator: const Divider(indent: AppSpacing.lg, height: 0))
          .toList(),
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
          onTap: () {
            context.pushNamed(AppRouteNames.transactionListFilterCategories);
          },
          leading: const Icon(IconsaxPlusBold.category),
          title: Text('Categories'.hardCoded),
          trailing: Text(categories.length.toString()),
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
          onTap: () {},
          leading: const Icon(IconsaxPlusBold.wallet),
          title: Text('Wallets'.hardCoded),
          trailing: Text(wallets.length.toString()),
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
          onTap: () {},
          leading: const Icon(IconsaxPlusBold.arrow_down),
          title: Text('Types'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...types.map((type) => Chip(label: Text(type.name))),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  const _DateRangeFilter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
        _TxDateRange>(
      selector: (state) => (from: state.filter.from, to: state.filter.to),
      builder: (context, range) {
        return ListTile(
          onTap: () {},
          leading: const Icon(IconsaxPlusBold.calendar),
          title: Text('Date Range'.hardCoded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (range.from != null || range.to != null)
                Chip(
                  label: Text(
                    range.from != null && range.to != null
                        ? '${range.from?.toLocal().toString()} - ${range.to?.toLocal().toString()}'
                        : range.from != null
                            ? range.from?.toLocal().toString() ?? ''
                            : range.to?.toLocal().toString() ?? '',
                  ),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
    );
  }
}
