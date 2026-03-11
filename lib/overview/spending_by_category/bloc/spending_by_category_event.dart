part of 'spending_by_category_bloc.dart';

sealed class SpendingByCategoryEvent extends Equatable {
  const SpendingByCategoryEvent();

  @override
  List<Object> get props => [];
}

final class SpendingByCategorySubscriptionRequested
    extends SpendingByCategoryEvent {}

class SpendingByCategorySelectedCategoryChanged
    extends SpendingByCategoryEvent {
  const SpendingByCategorySelectedCategoryChanged(
    this.selectedCategorySpendingStat,
  );
  final CategorySpendingStat? selectedCategorySpendingStat;
  @override
  List<Object> get props => [selectedCategorySpendingStat!];
}
