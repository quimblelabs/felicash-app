import 'package:app_ui/app_ui.dart';
import 'package:felicash/transaction/bloc/transaction_list_filter_cubit.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListFilterModal extends StatelessWidget {
  const TransactionListFilterModal({
    required this.navigation,
    this.initialFilter,
    super.key,
  });

  final TransactionListFilter? initialFilter;
  final Widget navigation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionListFilterCubit()
        ..updateFilter(initialFilter ?? TransactionListFilter.empty),
      child: ModalScaffold(
        header: const _Header(),
        content: navigation,
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
