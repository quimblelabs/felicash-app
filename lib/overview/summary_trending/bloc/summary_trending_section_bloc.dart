import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/overview/summary_trending/models/daily_summary.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

part 'summary_trending_section_event.dart';
part 'summary_trending_section_state.dart';

class SummaryTrendingSectionBloc
    extends Bloc<SummaryTrendingSectionEvent, SummaryTrendingSectionState> {
  SummaryTrendingSectionBloc() : super(const SummaryTrendingSectionState()) {
    on<SummaryTrendingSectionSubscriptionRequested>(
      _onSummaryTrendingSectionSubscriptionRequested,
    );
    on<SummaryTrendingSectionTransactionTypeChanged>(
      _onSummaryTrendingSectionTransactionTypeChanged,
    );
  }

  Future<void> _onSummaryTrendingSectionSubscriptionRequested(
    SummaryTrendingSectionSubscriptionRequested event,
    Emitter<SummaryTrendingSectionState> emit,
  ) async {
    emit(state.copyWith(status: SummaryTrendingSectionStatus.loading));

    try {
      // TODO(dangddt): Implement get daily summaries from API

      final summaries = _getFakeDailySummaries();
      emit(
        state.copyWith(
          status: SummaryTrendingSectionStatus.success,
          dailySummaries: summaries,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: SummaryTrendingSectionStatus.failure));
    }
  }

  void _onSummaryTrendingSectionTransactionTypeChanged(
    SummaryTrendingSectionTransactionTypeChanged event,
    Emitter<SummaryTrendingSectionState> emit,
  ) {
    emit(state.copyWith(selectedTransactionType: event.type));
  }

  List<DailySummary> _getFakeDailySummaries() {
    final summaries = <DailySummary>[];
    final today = DateTime.now();

    for (var i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final seed = Random().nextDouble() * 100;
      final seed2 = Random().nextDouble() * 100;
      final expense = seed * 1000;
      final income = seed2 * 1000;
      summaries.add(
        DailySummary(date: date, expense: -expense, income: income),
      );
    }
    return summaries;
  }
}
