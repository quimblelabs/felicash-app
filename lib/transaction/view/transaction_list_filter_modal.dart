import 'package:app_ui/app_ui.dart';
import 'package:app_utils/app_utils.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/transaction/bloc/transaction_list_filter_cubit.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

typedef _TxDateRange = ({DateTime? from, DateTime? to});

class TransactionListFilterModal extends StatelessWidget {
  const TransactionListFilterModal({
    super.key,
    this.initialFilter,
  });

  final TransactionListFilter? initialFilter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionListFilterCubit()
        ..updateFilter(initialFilter ?? TransactionListFilter.empty),
      child: const ModalScaffold(
        header: _Header(),
        content: _AllFilters(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text('Filters'.hardCoded);
  }
}

class _AllFilters extends StatelessWidget {
  const _AllFilters();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      children: <Widget>[
        BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
            Set<CategoryModel>>(
          selector: (state) => state.filter.categories,
          builder: (context, categories) {
            return ListTile(
              onTap: () {},
              leading: const Icon(IconsaxPlusBold.category),
              title: Text('Categories'.hardCoded),
              trailing: Text(categories.length.toString()),
            );
          },
        ),
        BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
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
        ),
        BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
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
        ),
        BlocSelector<TransactionListFilterCubit, TransactionListFilterState,
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
        ),
      ]
          .joinItems(separator: const Divider(indent: AppSpacing.lg, height: 0))
          .toList(),
    );
  }
}

class _AdjustCategories extends StatelessWidget {
  const _AdjustCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
