import 'package:bloc/bloc.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Color, IconData, Icons;
import 'package:form_inputs/form_inputs.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'wallet_creation_event.dart';
part 'wallet_creation_state.dart';

class WalletCreationBloc
    extends Bloc<WalletCreationEvent, WalletCreationState> {
  WalletCreationBloc({
    required WalletTypeEnum walletType,
    required CurrencyModel currency,
    required Color color,
  }) : super(
          WalletCreationState(
            walletType: walletType,
            color: color,
            currency: currency,
          ),
        ) {
    on<WalletCreationNameChanged>(_onWalletNameChanged);
    on<WalletCreationDescriptionChanged>(_onWalletDescriptionChanged);
    on<WalletCreationTypeChanged>(_onWalletTypeChanged);
    on<WalletCreationIconChanged>(_onWalletIconChanged);
    on<WalletCreationColorChanged>(_onWalletColorChanged);
    on<WalletCreationBalanceChanged>(_onWalletBalanceChanged);
    on<WalletCreationCurrencyChanged>(_onWalletCurrencyChanged);
    on<WalletCreationExcludeFromTotalChanged>(_onWalletExcludeFromTotalChanged);
    on<WalletCreationCreditLimitChanged>(_onWalletCreditLimitChanged);
    on<WalletCreationStateDayOfMonthChanged>(_onWalletStateDayOfMonthChanged);
    on<WalletCreationPaymentDayOfMonthChanged>(
      _onWalletPaymentDayOfMonthChanged,
    );
    on<WalletCreationSavingGoalChanged>(_onWalletSavingGoalChanged);
    on<WalletCreationSubmitted>(_onWalletCreationSubmitted);
  }

  void _onWalletNameChanged(
    WalletCreationNameChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final name = WalletName.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: _validateForm(name: name),
      ),
    );
  }

  void _onWalletDescriptionChanged(
    WalletCreationDescriptionChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final description = WalletDescription.dirty(event.description);
    emit(
      state.copyWith(
        description: description,
        isValid: _validateForm(description: description),
      ),
    );
  }

  void _onWalletTypeChanged(
    WalletCreationTypeChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    emit(
      state.copyWith(
        walletType: event.walletType,
      ),
    );
  }

  void _onWalletIconChanged(
    WalletCreationIconChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    emit(
      state.copyWith(
        icon: event.icon,
      ),
    );
  }

  void _onWalletColorChanged(
    WalletCreationColorChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    emit(
      state.copyWith(
        color: event.color,
      ),
    );
  }

  void _onWalletBalanceChanged(
    WalletCreationBalanceChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final balance = MonetaryAmount.dirty(event.balance);
    emit(
      state.copyWith(
        balance: balance,
        isValid: _validateForm(balance: balance),
      ),
    );
  }

  void _onWalletCurrencyChanged(
    WalletCreationCurrencyChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    emit(
      state.copyWith(
        currency: event.currency,
      ),
    );
  }

  void _onWalletExcludeFromTotalChanged(
    WalletCreationExcludeFromTotalChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    emit(
      state.copyWith(
        excludeFromTotal: event.excludeFromTotal,
      ),
    );
  }

  void _onWalletCreditLimitChanged(
    WalletCreationCreditLimitChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final creditLimit = WalletCreditLimit.dirty(event.creditLimit);
    emit(
      state.copyWith(
        creditLimit: creditLimit,
        isValid: _validateForm(creditLimit: creditLimit),
      ),
    );
  }

  void _onWalletStateDayOfMonthChanged(
    WalletCreationStateDayOfMonthChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final stateDayOfMonth = WalletStateDayOfMonth.dirty(
      event.stateDayOfMonth,
    );
    emit(
      state.copyWith(
        stateDayOfMonth: stateDayOfMonth,
        isValid: _validateForm(stateDayOfMonth: stateDayOfMonth),
      ),
    );
  }

  void _onWalletPaymentDayOfMonthChanged(
    WalletCreationPaymentDayOfMonthChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final paymentDayOfMonth = WalletPaymentDayOfMonth.dirty(
      event.paymentDayOfMonth,
    );
    emit(
      state.copyWith(
        paymentDayOfMonth: paymentDayOfMonth,
        isValid: _validateForm(paymentDayOfMonth: paymentDayOfMonth),
      ),
    );
  }

  void _onWalletSavingGoalChanged(
    WalletCreationSavingGoalChanged event,
    Emitter<WalletCreationState> emit,
  ) {
    final savingsGoal = MonetaryAmount.dirty(event.savingGoal);
    emit(
      state.copyWith(
        savingsGoal: savingsGoal,
        isValid: _validateForm(savingsGoal: savingsGoal),
      ),
    );
  }

  void _onWalletCreationSubmitted(
    WalletCreationSubmitted event,
    Emitter<WalletCreationState> emit,
  ) {
    if (!state.isValid) return;
    emit(state.copyWith(status: WalletCreationStatus.submiting));
    try {
      // TODO(tuanhm): Implement wallet creation logic
      // Here you would typically call the repository to create the wallet
      // For example: await _walletRepository.createWallet(...);
      emit(state.copyWith(status: WalletCreationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: WalletCreationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  bool _validateForm({
    WalletName? name,
    WalletDescription? description,
    MonetaryAmount? balance,
    WalletCreditLimit? creditLimit,
    WalletStateDayOfMonth? stateDayOfMonth,
    WalletPaymentDayOfMonth? paymentDayOfMonth,
    MonetaryAmount? savingsGoal,
  }) {
    final isValid = Formz.validate([
      name ?? state.name,
      description ?? state.description,
      balance ?? state.balance,
      if (state.walletType == WalletTypeEnum.credit) ...[
        creditLimit ?? state.creditLimit,
        stateDayOfMonth ?? state.stateDayOfMonth,
        paymentDayOfMonth ?? state.paymentDayOfMonth,
      ],
      if (state.walletType == WalletTypeEnum.savings) ...[
        savingsGoal ?? state.savingsGoal,
      ],
    ]);

    // Add any additional validation logic here

    return isValid;
  }
}
