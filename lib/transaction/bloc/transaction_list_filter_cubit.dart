import 'dart:async';

import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'transaction_list_filter_state.dart';

class TransactionListFilterCubit extends Cubit<TransactionListFilterState> {
  TransactionListFilterCubit()
      : super(
          const TransactionListFilterState(
            filter: TransactionListFilter.empty,
          ),
        );

  Timer? _searchDebounceTimer;

  void updateFilter(TransactionListFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
  }

  void updateSearchKey(String searchKey) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        emit(
          state.copyWith(
            filter: state.filter.copyWith(searchKey: searchKey),
          ),
        );
      },
    );
  }

  void updateCategories(Set<CategoryModel> categories) {
    emit(
      state.copyWith(
        filter: state.filter.copyWith(categories: categories),
      ),
    );
  }

  void updateTypes(Set<TransactionTypeEnum> types) {
    emit(
      state.copyWith(
        filter: state.filter.copyWith(types: types),
      ),
    );
  }

  void updateWallets(Set<BaseWalletModel> wallets) {
    emit(
      state.copyWith(
        filter: state.filter.copyWith(wallets: wallets),
      ),
    );
  }

  void updateFrom(DateTime from) {
    emit(state.copyWith(filter: state.filter.copyWith(from: from)));
  }

  void updateTo(DateTime to) {
    emit(state.copyWith(filter: state.filter.copyWith(to: to)));
  }

  void reset() {
    _searchDebounceTimer?.cancel();
    emit(const TransactionListFilterState(filter: TransactionListFilter.empty));
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
