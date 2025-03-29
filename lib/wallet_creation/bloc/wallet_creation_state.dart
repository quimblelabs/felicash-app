part of 'wallet_creation_bloc.dart';

enum WalletCreationStatus { initial, submiting, success, failure }

class WalletCreationState extends Equatable {
  const WalletCreationState({
    required this.walletType,
    required this.currency,
    required this.color,
    this.name = const WalletName.pure(),
    this.description = const WalletDescription.pure(),
    this.balance = const MonetaryAmount.pure(),
    this.excludeFromTotal = false,
    this.icon = Icons.wallet,
    this.creditLimit = const WalletCreditLimit.pure(),
    this.stateDayOfMonth = const WalletStateDayOfMonth.pure(),
    this.paymentDayOfMonth = const WalletPaymentDayOfMonth.pure(),
    this.savingsGoal = const MonetaryAmount.pure(),
    this.isValid = false,
    this.status = WalletCreationStatus.initial,
    this.errorMessage,
  });

  // -- Wallet creation data
  final WalletName name;
  final WalletDescription description;
  final WalletTypeEnum walletType;
  final IconData icon;
  final Color color;
  final CurrencyModel currency;
  final MonetaryAmount balance;
  final bool excludeFromTotal;
  // -- Ceredit wallet creation data
  final WalletCreditLimit creditLimit;
  final WalletStateDayOfMonth stateDayOfMonth;
  final WalletPaymentDayOfMonth paymentDayOfMonth;
  // -- Savings wallet creation data
  final MonetaryAmount savingsGoal;

  // -- Wallet creation validation and status
  final bool isValid;
  final WalletCreationStatus status;
  final String? errorMessage;

  WalletCreationState copyWith({
    WalletName? name,
    WalletDescription? description,
    WalletTypeEnum? walletType,
    IconData? icon,
    Color? color,
    MonetaryAmount? balance,
    CurrencyModel? currency,
    bool? excludeFromTotal,
    WalletCreditLimit? creditLimit,
    WalletStateDayOfMonth? stateDayOfMonth,
    WalletPaymentDayOfMonth? paymentDayOfMonth,
    MonetaryAmount? savingsGoal,
    bool? isValid,
    WalletCreationStatus? status,
    String? errorMessage,
  }) {
    return WalletCreationState(
      walletType: walletType ?? this.walletType,
      currency: currency ?? this.currency,
      name: name ?? this.name,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      excludeFromTotal: excludeFromTotal ?? this.excludeFromTotal,
      creditLimit: creditLimit ?? this.creditLimit,
      stateDayOfMonth: stateDayOfMonth ?? this.stateDayOfMonth,
      paymentDayOfMonth: paymentDayOfMonth ?? this.paymentDayOfMonth,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      status: status ?? this.status,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
      icon: icon ?? this.icon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      description,
      walletType,
      icon,
      color,
      currency,
      balance,
      excludeFromTotal,
      creditLimit,
      stateDayOfMonth,
      paymentDayOfMonth,
      savingsGoal,
      isValid,
      status,
      errorMessage,
    ];
  }
}
