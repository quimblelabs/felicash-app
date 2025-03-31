import 'package:currency_repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:wallet_repository/src/enums/wallet_type_enum.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

/// {@template credit_wallet_model}
/// Credit Wallet model
/// {@endtemplate}
class CreditWalletModel extends BaseWalletModel {
  /// {@macro credit_wallet_model}
  const CreditWalletModel({
    required super.id,
    required super.name,
    required super.baseCurrency,
    required super.balance,
    required super.createdAt,
    required super.updatedAt,
    required super.icon,
    required super.color,
    required super.excludeFromTotal,
    required super.isArchived,
    required this.creditLimit,
    required this.stateDayOfMonth,
    required this.paymentDueDayOfMonth,
    super.description,
    super.archivedAt,
    super.achieveReason,
  }) : super(walletType: WalletTypeEnum.credit);

  /// Creates a empty wallet model.
  static final empty = CreditWalletModel(
    id: '',
    name: '',
    color: Colors.black,
    baseCurrency: CurrencyModel.empty,
    balance: 0,
    creditLimit: 0,
    stateDayOfMonth: 0,
    paymentDueDayOfMonth: 0,
    icon: const EmojiIcon(raw: '', emoji: ''),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    excludeFromTotal: false,
    isArchived: false,
  );

  /// The credit limit of the wallet
  final double creditLimit;

  /// The state day of the wallet
  final int stateDayOfMonth;

  /// The payment due day of the wallet
  final int paymentDueDayOfMonth;
}
