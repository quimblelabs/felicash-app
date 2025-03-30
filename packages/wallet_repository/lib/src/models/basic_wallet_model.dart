import 'package:currency_repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:wallet_repository/src/enums/wallet_type_enum.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

/// {@template basic_wallet_model}
/// Basic Wallet model
/// {@endtemplate}
class BasicWalletModel extends BaseWalletModel {
  /// {@macro basic_wallet_model}
  const BasicWalletModel({
    required super.id,
    required super.name,
    required super.baseCurrency,
    required super.balance,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required super.excludeFromTotal,
    required super.isArchived,
    required super.icon,
    super.description,
    super.archivedAt,
    super.achieveReason,
  }) : super(walletType: WalletTypeEnum.basic);

  /// Creates a empty wallet model.
  static final empty = BasicWalletModel(
    id: '',
    name: '',
    baseCurrency: CurrencyModel.empty,
    balance: 0,
    color: Colors.black,
    icon: const EmojiIcon(raw: '', emoji: ''),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    excludeFromTotal: false,
    isArchived: false,
  );

  /// Checks if the wallet is empty.
  bool get isEmpty => this == BasicWalletModel.empty;
}
