import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/transaction/cubit/transaction_list_filter_cubit.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:felicash/transaction/transaction_list/bloc/transactions_bloc.dart';
import 'package:felicash/transaction/transaction_list/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:transaction_repository/transaction_repository.dart';

part '../widgets/transaction_list.dart';
part '../widgets/transaction_list_filter_button.dart';
part '../widgets/transaction_list_search_bar.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsBloc(
            transactionRepository: context.read<TransactionRepository>(),
          )..add(const TransactionsInitialSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => TransactionListFilterCubit(
            initialFilter: TransactionListFilter.empty,
          ),
        ),
      ],
      child: const _OnFilterUpdated(
        child: TransactionsView(),
      ),
    );
  }
}

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverAppBar.medium(
                  centerTitle: false,
                  title: Text(l10n.transactionPageTitle),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: TransactionListSearchBar()),
                          TransactionListFilterButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.sm,
                    0,
                    AppSpacing.xxxlg,
                  ),
                  sliver: TransactionList(
                    scrollController: _scrollController,
                  ),
                ),
              ],
            ),
            ScrollToTopButton(
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _OnFilterUpdated extends StatelessWidget {
  const _OnFilterUpdated({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionListFilterCubit, TransactionListFilterState>(
      listenWhen: (previous, current) => previous.filter != current.filter,
      listener: (context, state) {
        context.read<TransactionsBloc>().add(
              TransactionsInitialSubscriptionRequested(filter: state.filter),
            );
      },
      child: child,
    );
  }
}
