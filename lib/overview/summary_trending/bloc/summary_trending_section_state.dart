part of 'summary_trending_section_bloc.dart';

enum SummaryTrendingSectionStatus { initial, loading, success, failure }

final class SummaryTrendingSectionState extends Equatable {
  const SummaryTrendingSectionState({
    this.status = SummaryTrendingSectionStatus.initial,
    this.selectedTransactionType = TransactionTypeEnum.expense,
    this.dailySummaries = const [],
  });

  final TransactionTypeEnum selectedTransactionType;
  final SummaryTrendingSectionStatus status;
  final List<DailySummary> dailySummaries;

  SummaryTrendingSectionState copyWith({
    SummaryTrendingSectionStatus? status,
    TransactionTypeEnum? selectedTransactionType,
    List<DailySummary>? dailySummaries,
  }) {
    return SummaryTrendingSectionState(
      status: status ?? this.status,
      selectedTransactionType:
          selectedTransactionType ?? this.selectedTransactionType,
      dailySummaries: dailySummaries ?? this.dailySummaries,
    );
  }

  @override
  List<Object?> get props => [status, selectedTransactionType, dailySummaries];
}
