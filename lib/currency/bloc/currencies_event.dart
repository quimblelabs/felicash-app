part of 'currencies_bloc.dart';

sealed class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();

  @override
  List<Object> get props => [];
}

class CurrenciesFetched extends CurrenciesEvent {
  const CurrenciesFetched();

  @override
  List<Object> get props => [];
}
