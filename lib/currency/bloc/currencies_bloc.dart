import 'dart:developer' as developer;

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
    on<CurrenciesFetched>(_onCurrenciesSubscriptionRequested);
  }

  final CurrencyRepository _currencyRepository;

  Future<void> _onCurrenciesSubscriptionRequested(
    CurrenciesFetched event,
    Emitter<CurrenciesState> emit,
  ) async {
    emit(const CurrenciesLoadInProgress());
    await _currencyRepository.getCurrencies().then((currencies) {
      emit(CurrenciesLoadSuccess(currencies: currencies));
    }).onError(
      (error, stackTrace) {
        developer.log(error.toString(), error: error, stackTrace: stackTrace);
        emit(CurrenciesLoadFailure(error: error ?? 'Unknown error'));
      },
    );
  }
}
