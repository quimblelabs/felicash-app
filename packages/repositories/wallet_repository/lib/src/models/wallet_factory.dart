import 'package:currency_repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';
import 'package:wallet_repository/src/models/basic_wallet_model.dart';
import 'package:wallet_repository/src/models/credit_wallet_model.dart';
import 'package:wallet_repository/src/models/savings_walllet_model.dart';

/// {@template wallet_factory}
/// Factory class for creating different types of wallets
/// {@endtemplate}
abstract class WalletFactory {
  /// Creates a new wallet based on the wallet type
  static BaseWalletModel createWallet({
    required String id,
    required String name,
    required WalletTypeEnum walletType,
    required CurrencyModel baseCurrency,
    required double balance,
    required Color color,
    required RawIconData icon,
    String? description,
    bool excludeFromTotal = false,
    bool isArchived = false,
    DateTime? archivedAt,
    String? achieveReason,
    // Savings wallet specific parameters
    double? savingsGoal,
    // Credit wallet specific parameters
    double? creditLimit,
    int? stateDayOfMonth,
    int? paymentDueDayOfMonth,
  }) {
    final now = DateTime.now();

    switch (walletType) {
      case WalletTypeEnum.basic:
        return BasicWalletModel(
          id: id,
          name: name,
          currencyCode: baseCurrency.code,
          balance: balance,
          color: color,
          icon: icon,
          description: description,
          excludeFromTotal: excludeFromTotal,
          isArchived: isArchived,
          archivedAt: archivedAt,
          achieveReason: achieveReason,
          createdAt: now,
          updatedAt: now,
        );
      case WalletTypeEnum.savings:
        if (savingsGoal == null) {
          throw ArgumentError('savingsGoal is required for savings wallet');
        }
        return SavingsWalletModel(
          id: id,
          name: name,
          currencyCode: baseCurrency.code,
          balance: balance,
          color: color,
          icon: icon,
          description: description,
          excludeFromTotal: excludeFromTotal,
          isArchived: isArchived,
          archivedAt: archivedAt,
          achieveReason: achieveReason,
          createdAt: now,
          updatedAt: now,
          savingsGoal: savingsGoal,
        );
      case WalletTypeEnum.credit:
        if (creditLimit == null ||
            stateDayOfMonth == null ||
            paymentDueDayOfMonth == null) {
          throw ArgumentError(
            'creditLimit, stateDayOfMonth, and paymentDueDayOfMonth are required for credit wallet',
          );
        }
        return CreditWalletModel(
          id: id,
          name: name,
          currencyCode: baseCurrency.code,
          balance: balance,
          color: color,
          icon: icon,
          description: description,
          excludeFromTotal: excludeFromTotal,
          isArchived: isArchived,
          archivedAt: archivedAt,
          achieveReason: achieveReason,
          createdAt: now,
          updatedAt: now,
          creditLimit: creditLimit,
          stateDayOfMonth: stateDayOfMonth,
          paymentDueDayOfMonth: paymentDueDayOfMonth,
        );
    }
  }

  /// Creates a wallet from JSON data
  static BaseWalletModel fromJson(Map<String, dynamic> json) {
    return BaseWalletModel.fromJson(json);
  }

  /// Creates an empty wallet of the specified type
  static BaseWalletModel createEmptyWallet(WalletTypeEnum walletType) {
    switch (walletType) {
      case WalletTypeEnum.basic:
        return BasicWalletModel.empty;
      case WalletTypeEnum.savings:
        return SavingsWalletModel.empty;
      case WalletTypeEnum.credit:
        return CreditWalletModel.empty;
    }
  }
}
