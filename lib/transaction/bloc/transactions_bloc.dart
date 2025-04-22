import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/transaction/bloc/mock_txs_repo.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(const TransactionsState.initial()) {
    on<TransactionsInitialSubscriptionRequested>(
      _onInitialSubscriptionRequested,
    );
    on<TransactionsNextSubscriptionRequested>(
      _onNextSubscriptionRequested,
    );
  }

  final _transactionRepository = MockTransactionRepository();
  final List<List<TransactionModel>> _pagedData = [];
  DateTime? _lastCreatedAt;

  Future<void> _onInitialSubscriptionRequested(
    TransactionsInitialSubscriptionRequested event,
    Emitter<TransactionsState> emit,
  ) {
    _pagedData.clear();
    emit(const TransactionsState.loading());
    return emit.forEach(
      _transactionRepository.fetchPage(pageIndex: 0),
      onData: (transactions) {
        // Replace or insert the first page
        if (_pagedData.isEmpty) {
          _pagedData.add(transactions);
        } else {
          _pagedData[0] = transactions;
        }
        _updateLastCreatedAt();
        return _buildState();
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
    final last = _lastCreatedAt;
    if (last == null) {
      return Future.value();
    }

    final pageIndex = _pagedData.length;
    return emit.forEach(
      _transactionRepository.fetchPage(pageIndex: pageIndex, before: last),
      onData: (transactions) {
        // Replace or add the page at the correct index
        if (_pagedData.length > pageIndex) {
          _pagedData[pageIndex] = transactions;
        } else {
          _pagedData.add(transactions);
        }
        _updateLastCreatedAt();
        return _buildState();
      },
    );
  }

  /// Helper to update _lastCreatedAt based on the combined list
  void _updateLastCreatedAt() {
    final combined = _pagedData.expand((page) => page).toList();
    _lastCreatedAt = combined.isNotEmpty ? combined.last.createdAt : null;
  }

  /// Helper to build the current state based on the paged data
  TransactionsState _buildState() {
    final combined = _pagedData.expand((page) => page).toList();
    final hasReachedEnd = _pagedData.isEmpty ||
        _pagedData.last.length < MockTransactionRepository.pageSize;

    return TransactionsState(
      transactions: combined,
      hasReachedEnd: hasReachedEnd,
      status: TransactionsStatus.success,
    );
  }
}
