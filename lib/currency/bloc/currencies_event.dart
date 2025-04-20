part of 'currencies_bloc.dart';

sealed class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();

  @override
  List<Object> get props => [];
}

class CurrenciesSubscriptionRequested extends CurrenciesEvent {
  const CurrenciesSubscriptionRequested({
    required this.query,
  });

  final GetCurrencyQuery query;

  @override
  List<Object> get props => [query];
}

class CurrenciesSubscriptionRetry extends CurrenciesEvent {
  const CurrenciesSubscriptionRetry({
    required this.query,
  });

  final GetCurrencyQuery query;

  @override
  List<Object> get props => [query];
}
