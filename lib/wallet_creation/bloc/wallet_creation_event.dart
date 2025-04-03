part of 'wallet_creation_bloc.dart';

sealed class WalletCreationEvent extends Equatable {
  const WalletCreationEvent();

  @override
  List<Object> get props => [];
}

class WalletCreationNameChanged extends WalletCreationEvent {
  const WalletCreationNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class WalletCreationDescriptionChanged extends WalletCreationEvent {
  const WalletCreationDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class WalletCreationTypeChanged extends WalletCreationEvent {
  const WalletCreationTypeChanged(this.walletType);

  final WalletTypeEnum walletType;

  @override
  List<Object> get props => [walletType];
}

class WalletCreationIconChanged extends WalletCreationEvent {
  const WalletCreationIconChanged(this.icon);

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

class WalletCreationColorChanged extends WalletCreationEvent {
  const WalletCreationColorChanged(this.color);

  final Color color;

  @override
  List<Object> get props => [color];
}

class WalletCreationBalanceChanged extends WalletCreationEvent {
  const WalletCreationBalanceChanged(this.balance);

  final double balance;

  @override
  List<Object> get props => [balance];
}

class WalletCreationCurrencyChanged extends WalletCreationEvent {
  const WalletCreationCurrencyChanged(this.currency);

  final CurrencyModel currency;

  @override
  List<Object> get props => [currency];
}

class WalletCreationExcludeFromTotalChanged extends WalletCreationEvent {
  // ignore: avoid_positional_boolean_parameters
  const WalletCreationExcludeFromTotalChanged(this.excludeFromTotal);
  final bool excludeFromTotal;
  @override
  List<Object> get props => [excludeFromTotal];
}

class WalletCreationCreditLimitChanged extends WalletCreationEvent {
  const WalletCreationCreditLimitChanged(this.creditLimit);
  final double creditLimit;
  @override
  List<Object> get props => [creditLimit];
}

class WalletCreationStateDayOfMonthChanged extends WalletCreationEvent {
  const WalletCreationStateDayOfMonthChanged(this.stateDayOfMonth);
  final int stateDayOfMonth;
  @override
  List<Object> get props => [stateDayOfMonth];
}

class WalletCreationPaymentDayOfMonthChanged extends WalletCreationEvent {
  const WalletCreationPaymentDayOfMonthChanged(this.paymentDayOfMonth);
  final int paymentDayOfMonth;
  @override
  List<Object> get props => [paymentDayOfMonth];
}

class WalletCreationSavingGoalChanged extends WalletCreationEvent {
  const WalletCreationSavingGoalChanged(this.savingGoal);
  final double savingGoal;
  @override
  List<Object> get props => [savingGoal];
}

class WalletCreationSubmitted extends WalletCreationEvent {
  const WalletCreationSubmitted();
}
