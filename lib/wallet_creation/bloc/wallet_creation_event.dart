part of 'wallet_creation_bloc.dart';

sealed class WalletCreationEvent extends Equatable {
  const WalletCreationEvent();

  @override
  List<Object> get props => [];
}

class WalletNameChanged extends WalletCreationEvent {
  const WalletNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class WalletDescriptionChanged extends WalletCreationEvent {
  const WalletDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class WalletTypeChanged extends WalletCreationEvent {
  const WalletTypeChanged(this.walletType);

  final WalletTypeEnum walletType;

  @override
  List<Object> get props => [walletType];
}

class WalletIconChanged extends WalletCreationEvent {
  const WalletIconChanged(this.icon);

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

class WalletColorChanged extends WalletCreationEvent {
  const WalletColorChanged(this.color);

  final Color color;

  @override
  List<Object> get props => [color];
}

class WalletBalanceChanged extends WalletCreationEvent {
  const WalletBalanceChanged(this.balance);

  final double balance;

  @override
  List<Object> get props => [balance];
}

class WalletCurrencyChanged extends WalletCreationEvent {
  const WalletCurrencyChanged(this.currency);

  final CurrencyModel currency;

  @override
  List<Object> get props => [currency];
}

class WalletExcludeFromTotalChanged extends WalletCreationEvent {
  // ignore: avoid_positional_boolean_parameters
  const WalletExcludeFromTotalChanged(this.excludeFromTotal);
  final bool excludeFromTotal;
  @override
  List<Object> get props => [excludeFromTotal];
}

class WalletCreditLimitChanged extends WalletCreationEvent {
  const WalletCreditLimitChanged(this.creditLimit);
  final double creditLimit;
  @override
  List<Object> get props => [creditLimit];
}

class WalletStateDayOfMonthChanged extends WalletCreationEvent {
  const WalletStateDayOfMonthChanged(this.stateDayOfMonth);
  final int stateDayOfMonth;
  @override
  List<Object> get props => [stateDayOfMonth];
}

class WalletPaymentDayOfMonthChanged extends WalletCreationEvent {
  const WalletPaymentDayOfMonthChanged(this.paymentDayOfMonth);
  final int paymentDayOfMonth;
  @override
  List<Object> get props => [paymentDayOfMonth];
}

class WalletSavingGoalChanged extends WalletCreationEvent {
  const WalletSavingGoalChanged(this.savingGoal);
  final double savingGoal;
  @override
  List<Object> get props => [savingGoal];
}

class WalletCreationSubmitted extends WalletCreationEvent {
  const WalletCreationSubmitted();
}
