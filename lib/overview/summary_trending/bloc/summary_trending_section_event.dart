part of 'summary_trending_section_bloc.dart';

sealed class SummaryTrendingSectionEvent extends Equatable {
  const SummaryTrendingSectionEvent();

  @override
  List<Object> get props => [];
}

class SummaryTrendingSectionSubscriptionRequested
    extends SummaryTrendingSectionEvent {}

class SummaryTrendingSectionTransactionTypeChanged
    extends SummaryTrendingSectionEvent {
  const SummaryTrendingSectionTransactionTypeChanged(this.type);
  final TransactionTypeEnum type;
}
