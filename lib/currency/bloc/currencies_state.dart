part of 'currencies_bloc.dart';

sealed class CurrenciesState extends Equatable {
  const CurrenciesState();

  @override
  List<Object?> get props => [];
}

final class CurrenciesInitial extends CurrenciesState {
  const CurrenciesInitial();

  @override
  List<Object?> get props => [];
}

final class CurrenciesLoadInProgress extends CurrenciesState {
  const CurrenciesLoadInProgress({
    this.currencies = const [],
    this.messageText = 'Loading currencies...',
  });
  final List<CurrencyModel> currencies;
  final String messageText;

  @override
  List<Object?> get props => [currencies, messageText];
}

final class CurrenciesLoadSuccess extends CurrenciesState {
  const CurrenciesLoadSuccess({
    this.currencies = const [],
  });
  final List<CurrencyModel> currencies;

  @override
  List<Object?> get props => [currencies];
}

final class CurrenciesLoadFailure extends CurrenciesState {
  const CurrenciesLoadFailure({
    required this.error,
    required this.previousQuery,
    this.messageText = 'Error when load currencies',
  });
  final String messageText;
  final Object error;
  final GetCurrencyQuery previousQuery;

  @override
  List<Object?> get props => [messageText, error, previousQuery];
}
