import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

const _pageSize = 10;

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepository = transactionRepository,
        super(const TransactionsState.initial()) {
    on<TransactionsInitialSubscriptionRequested>(
      _onInitialSubscriptionRequested,
      transformer: restartable(),
    );
    on<TransactionsNextSubscriptionRequested>(
      _onNextSubscriptionRequested,
    );
  }

  final TransactionRepository _transactionRepository;
  final List<List<TransactionModel>> _pagedData = [];
  TransactionListFilter _activeFilter = TransactionListFilter.empty;

  Future<void> _onInitialSubscriptionRequested(
    TransactionsInitialSubscriptionRequested event,
    Emitter<TransactionsState> emit,
  ) {
    _activeFilter = event.filter;
    _pagedData.clear();
    emit(const TransactionsState.loading());
    final query = event.filter.toGetTransactionQuery(pageIndex: 0);
    return emit.forEach(
      _transactionRepository.getTransactions(query),
      onData: (transactions) {
        // Replace or insert the first page
        if (_pagedData.isEmpty) {
          _pagedData.add(transactions);
        } else {
          _pagedData[0] = transactions;
        }
        return _buildState();
      },
      onError: (error, stackTrace) {
        // TODO(tuanhm): Handle error each page
        return state.copyWith(
          status: TransactionsStatus.failure,
        );
      },
    );
  }

  Future<void> _onNextSubscriptionRequested(
    TransactionsNextSubscriptionRequested event,
    Emitter<TransactionsState> emit,
  ) {
    if (state.hasReachedEnd || state.status == TransactionsStatus.loading) {
      return Future.value();
    }

    emit(state.copyWith(status: TransactionsStatus.loading));
    final pageIndex = _pagedData.length;
    final query = _activeFilter.toGetTransactionQuery(
      pageIndex: pageIndex,
    );
    return emit.forEach(
      _transactionRepository.getTransactions(query),
      onData: (transactions) {
        // Replace or add the page at the correct index

        if (_pagedData.length > pageIndex) {
          _pagedData[pageIndex] = transactions;
        } else {
          _pagedData.add(transactions);
        }
        return _buildState();
      },
      onError: (error, stackTrace) {
        // TODO(tuanhm): Handle error each page
        return state.copyWith(
          status: TransactionsStatus.failure,
        );
      },
    );
  }

  /// Helper to build the current state based on the paged data
  TransactionsState _buildState() {
    final combined = _pagedData.expand((page) => page).toList()
      ..sort((a, b) {
        final byTransactionDate =
            b.transactionDate.compareTo(a.transactionDate);
        if (byTransactionDate != 0) {
          return byTransactionDate;
        }
        final byCreatedAt = b.createdAt.compareTo(a.createdAt);
        if (byCreatedAt != 0) {
          return byCreatedAt;
        }
        return b.id.compareTo(a.id);
      });

    final deduplicated = <TransactionModel>[];
    final ids = <String>{};
    for (final transaction in combined) {
      if (ids.add(transaction.id)) {
        deduplicated.add(transaction);
      }
    }

    final hasReachedEnd =
        _pagedData.isEmpty || _pagedData.last.length < _pageSize;

    return TransactionsState(
      transactions: deduplicated,
      hasReachedEnd: hasReachedEnd,
      status: TransactionsStatus.success,
    );
  }
}

extension on TransactionListFilter {
  GetTransactionQuery toGetTransactionQuery({
    required int pageIndex,
    DateTime? start,
    DateTime? end,
  }) {
    return GetTransactionQuery(
      pageIndex: pageIndex,
      pageSize: _pageSize,
      startDate: start ?? from,
      endDate: end ?? to,
      // TODO(dangddt): Add multiple transaction type
      transactionType: types.firstOrNull,
      // TODO(dangddt): Add multiple category id
      categoryId: categories.firstOrNull?.id,
      // TODO(dangddt): Add multiple wallet id
      walletId: wallets.firstOrNull?.wallet.id,
      transactionNotes: searchKey,
    );
  }
}
