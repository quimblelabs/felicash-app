import 'package:bloc/bloc.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';

part 'currencies_event.dart';
part 'currencies_state.dart';

class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  CurrenciesBloc({
    required CurrencyRepository currencyRepository,
  })  : _currencyRepository = currencyRepository,
        super(const CurrenciesInitial()) {
    on<CurrenciesSubscriptionRequested>(_onCurrenciesSubscriptionRequested);
    on<CurrenciesSubscriptionRetry>(_onCurrenciesSubscriptionRetry);
  }

  final CurrencyRepository _currencyRepository;

  Future<void> _onCurrenciesSubscriptionRequested(
    CurrenciesSubscriptionRequested event,
    Emitter<CurrenciesState> emit,
  ) async {
    emit(const CurrenciesLoadInProgress());
    await emit.forEach<List<CurrencyModel>>(
      _currencyRepository.getCurrencies(event.query),
      onData: (currencies) => CurrenciesLoadSuccess(currencies: currencies),
      onError: (error, stackTrace) => CurrenciesLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }

  Future<void> _onCurrenciesSubscriptionRetry(
    CurrenciesSubscriptionRetry event,
    Emitter<CurrenciesState> emit,
  ) async {
    emit(const CurrenciesLoadInProgress());
    await emit.forEach<List<CurrencyModel>>(
      _currencyRepository.getCurrencies(event.query),
      onData: (currencies) => CurrenciesLoadSuccess(currencies: currencies),
      onError: (error, stackTrace) => CurrenciesLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }
}
