import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_models/shared_models.dart';

/// {@template base_wallet_model}
/// Base wallet model for all wallet types
/// {@endtemplate}
class BaseWalletModel extends Equatable {
  /// {@macro base_wallet_model}
  const BaseWalletModel({
    required this.id,
    required this.name,
    required this.walletType,
    required this.baseCurrency,
    required this.balance,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.excludeFromTotal,
    required this.isArchived,
    required this.icon,
    this.description,
    this.archivedAt,
    this.achieveReason,
  });

  /// The unique identifier of the wallet
  final String id;

  /// The name of the wallet
  final String name;

  /// Optional description of the wallet
  final String? description;

  /// The type of wallet (e.g. cash, bank, credit card)
  final WalletTypeEnum walletType;

  /// The base currency used for this wallet
  final CurrencyModel baseCurrency;

  /// The current balance of the wallet
  final double balance;

  /// The icon representing the wallet
  final RawIconData icon;

  /// The color used for displaying the wallet
  final Color color;

  /// The timestamp when the wallet was created
  final DateTime createdAt;

  /// The timestamp when the wallet was last updated
  final DateTime updatedAt;

  /// Whether to exclude this wallet from total calculations
  final bool excludeFromTotal;

  /// Whether the wallet is archived
  final bool isArchived;

  /// The timestamp when the wallet was archived, if applicable
  final DateTime? archivedAt;

  /// The reason why the wallet was archived, if applicable
  final String? achieveReason;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      walletType,
      baseCurrency,
      balance,
      createdAt,
      updatedAt,
      excludeFromTotal,
      isArchived,
      archivedAt,
      achieveReason,
    ];
  }
}
