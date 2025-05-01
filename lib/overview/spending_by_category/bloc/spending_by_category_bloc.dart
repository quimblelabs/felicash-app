import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/overview/spending_by_category/models/category_spending_stat.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'spending_by_category_event.dart';
part 'spending_by_category_state.dart';

class SpendingByCategoryBloc
    extends Bloc<SpendingByCategoryEvent, SpendingByCategoryState> {
  SpendingByCategoryBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepository = transactionRepository,
        super(const SpendingByCategoryState()) {
    on<SpendingByCategorySubscriptionRequested>(
      _onSpendingByCategorySubscriptionRequested,
    );
    on<SpendingByCategorySelectedCategoryChanged>(
      _onSpendingByCategorySelectedCategoryChanged,
    );
  }

  final TransactionRepository _transactionRepository;

  Future<void> _onSpendingByCategorySubscriptionRequested(
    SpendingByCategorySubscriptionRequested event,
    Emitter<SpendingByCategoryState> emit,
  ) async {
    emit(state.copyWith(status: SpendingByCategoryStatus.loading));
    final now = DateTime.now();
    await emit.forEach<List<TransactionSummaryByCategoryModel>>(
      // TODO(tuanhm): remove hard code currency id
      _transactionRepository.getTransactionSummaryByCategory(
        GetTransactionSummaryByCategoryQuery(
          convertToCurrencyCode: 'VND'.hardCoded,
          transactionType: TransactionTypeEnum.expense,
          startDate: now.startOfMonth(),
          endDate: now.endOfMonth(),
        ),
      ),
      onData: (result) {
        final data =
            CategorySpendingStatListX.fromTransactionSummaryByCategoryModels(
          result,
        );
        return state.copyWith(
          status: SpendingByCategoryStatus.success,
          categorySpendingStats: data,
          selectedCategorySpendingStat: data.firstOrNull,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          status: SpendingByCategoryStatus.failure,
        );
      },
    );
  }

  void _onSpendingByCategorySelectedCategoryChanged(
    SpendingByCategorySelectedCategoryChanged event,
    Emitter<SpendingByCategoryState> emit,
  ) {
    emit(
      state.setSelectedCategorySpendingStat(event.selectedCategorySpendingStat),
    );
  }

  List<CategorySpendingStat> _transformData(
    List<CategorySpendingStat> categorySpendingStats, {
    required int take,
  }) {
    if (take > categorySpendingStats.length) {
      return categorySpendingStats;
    }

    // Sort once and use for both operations
    final sortedStats = categorySpendingStats
      ..sort((a, b) => b.spending.compareTo(a.spending));

    final topStats = sortedStats.take(take).toList();
    final remainingStats = sortedStats.skip(take);

    // Calculate others stats in single iteration if needed
    final othersStats = remainingStats.fold<Map<String, num>>(
      {'spending': 0, 'count': 0},
      (acc, stat) => {
        'spending': acc['spending']! + stat.spending,
        'count': acc['count']! + stat.transactionCount,
      },
    );

    if (othersStats['spending']! > 0) {
      topStats.add(
        CategorySpendingStat(
          category: CategoryModel.empty.copyWith(
            name: 'Others',
            icon: IconDataIcon.fromIconData(Icons.more_vert_rounded),
            color: Colors.grey,
          ),
          spending: othersStats['spending']! as double,
          transactionCount: othersStats['count']! as int,
        ),
      );
    }

    return topStats;
  }

  final List<CategorySpendingStat> _fakeCategorySpendingStats = [
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Food',
        color: Colors.red,
      ),
      spending: 1000,
      transactionCount: 3,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Transportation',
        color: Colors.blue,
      ),
      spending: 2045,
      transactionCount: 20,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Shopping',
        color: Colors.green,
      ),
      spending: 7840,
      transactionCount: 30,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Entertainment',
        color: Colors.purple,
      ),
      spending: 3500,
      transactionCount: 15,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Healthcare',
        color: Colors.orange,
      ),
      spending: 5200,
      transactionCount: 8,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Education',
        color: Colors.teal,
      ),
      spending: 4300,
      transactionCount: 12,
    ),
    CategorySpendingStat(
      category: CategoryModel.empty.copyWith(
        name: 'Utilities',
        color: Colors.brown,
      ),
      spending: 2800,
      transactionCount: 6,
    ),
  ];
}
