import 'package:currency_repository/currency_repository.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
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

  /// Factory constructor for [BasicWalletModel] from [BaseWalletModel]
  factory BasicWalletModel.fromBaseWalletModel({
    required BaseWalletModel baseWalletModel,
  }) {
    return BasicWalletModel(
      id: baseWalletModel.id,
      name: baseWalletModel.name,
      baseCurrency: baseWalletModel.baseCurrency,
      balance: baseWalletModel.balance,
      icon: baseWalletModel.icon,
      color: baseWalletModel.color,
      createdAt: baseWalletModel.createdAt,
      updatedAt: baseWalletModel.updatedAt,
      excludeFromTotal: baseWalletModel.excludeFromTotal,
      isArchived: baseWalletModel.isArchived,
      description: baseWalletModel.description,
      archivedAt: baseWalletModel.archivedAt,
      achieveReason: baseWalletModel.achieveReason,
    );
  }

  /// Factory constructor for [BasicWalletModel] from [Wallet]
  factory BasicWalletModel.fromWallet({
    required Wallet wallet,
  }) {
    return BasicWalletModel(
      id: wallet.walletId,
      name: wallet.walletName,
      description: wallet.walletDescription,
      baseCurrency: CurrencyModel(
        id: wallet.currencies.first.currencyId,
        code: wallet.currencies.first.currencyCode,
        name: wallet.currencies.first.currencyName,
        symbol: wallet.currencies.first.currencySymbol,
        createdAt: wallet.currencies.first.currencyCreatedAt,
        updatedAt: wallet.currencies.first.currencyUpdatedAt,
      ),
      balance: wallet.walletBalance,
      color: HexColor.fromHex(wallet.walletColor),
      icon: RawIconData.fromRaw(wallet.walletIcon),
      excludeFromTotal: wallet.walletExcludeFromTotal,
      isArchived: wallet.walletArchived,
      achieveReason: wallet.walletArchiveReason,
      archivedAt: wallet.walletArchivedAt,
      createdAt: wallet.walletCreatedAt,
      updatedAt: wallet.walletUpdatedAt,
    );
  }

  /// Creates a empty wallet model.
  static final empty = BasicWalletModel(
    id: '',
    name: '',
    baseCurrency: CurrencyModel.empty,
    balance: 0,
    color: Colors.black,
    icon: const EmojiDataIcon(raw: '', emoji: ''),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    excludeFromTotal: false,
    isArchived: false,
  );

  /// Checks if the wallet is empty.
  bool get isEmpty => this == BasicWalletModel.empty;
}
