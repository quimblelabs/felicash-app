part of '../view/transactions_page.dart';

/// A widget that displays a list of transactions grouped by date with infinite scroll
class TransactionList extends StatefulWidget {
  const TransactionList({
    required this.scrollController,
    super.key,
  });
  final ScrollController scrollController;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        switch (state.status) {
          case TransactionsStatus.failure:
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  l10n.transactionListFailedToFetchTransactionsErrorMessage,
                ),
              ),
            );
          case TransactionsStatus.success:
          case TransactionsStatus.loading:
            if (state.transactions.isEmpty) {
              return SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.transactionListNoTransactionsFoundErrorMessage),
                    Text(l10n.transactionListAddTransactionToGetStartedText),
                  ],
                ),
              );
            }

            final groupedTransactions =
                _groupTransactionsByDate(state.transactions);
            final sortedDates = groupedTransactions.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            final sections = sortedDates.map(
              (date) {
                final transactions = groupedTransactions[date]!;
                return _Section(
                  items: [
                    SliverPinnedHeader(
                      child: _DateHeader(date: date),
                    ),
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                      ),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) => _TransactionListItem(
                          transaction: transactions[index],
                        ),
                        separatorBuilder: (context, index) => const Divider(
                          height: 0,
                          indent: AppSpacing.md,
                          endIndent: AppSpacing.md,
                        ),
                        itemCount: transactions.length,
                      ),
                    ),
                  ],
                );
              },
            );

            return MultiSliver(
              children: [
                ...sections,
                if (!state.hasReachedEnd)
                  const SliverToBoxAdapter(child: _BottomLoader()),
              ],
            );

          case TransactionsStatus.initial:
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }

  /// Groups transactions by their date (year, month, day)
  Map<DateTime, List<TransactionModel>> _groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    final groupedTransactions = <DateTime, List<TransactionModel>>{};
    for (final transaction in transactions) {
      final date = DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      );
      groupedTransactions.putIfAbsent(date, () => []).add(transaction);
    }
    return groupedTransactions;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  /// Handles infinite scroll by requesting more transactions when near the bottom
  void _onScroll() {
    if (_isBottom) {
      context
          .read<TransactionsBloc>()
          .add(const TransactionsNextSubscriptionRequested());
    }
  }

  /// Returns true if the user has scrolled to 90% of the list
  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final theme = Theme.of(context);
    final l10n = context.l10n;

    String dateText;
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      dateText = l10n.today;
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      dateText = l10n.yesterday;
    } else {
      dateText = date.yMMMMEEEEd(l10n.localeName);
    }

    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface.withValues(alpha: .9),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        dateText,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  const _TransactionListItem({
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TransactionItem(transaction: transaction),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}

class _Section extends MultiSliver {
  _Section({
    required List<Widget> items,
    super.key,
  }) : super(
          pushPinnedChildren: true,
          children: items,
        );
}
