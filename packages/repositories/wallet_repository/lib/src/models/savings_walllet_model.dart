import 'package:currency_repository/currency_repository.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

part 'savings_walllet_model.g.dart';

/// {@template savings_wallet_model}
/// Savings Wallet Model
/// {@endtemplate}
@JsonSerializable(
  converters: [HexColorConverter(), RawIconDataConverter()],
)
class SavingsWalletModel extends BaseWalletModel {
  /// {@macro savings_wallet_model}
  const SavingsWalletModel({
    required super.id,
    required super.name,
    required super.baseCurrency,
    required super.balance,
    required super.icon,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required super.excludeFromTotal,
    required super.isArchived,
    required this.savingsGoal,
    super.description,
    super.archivedAt,
    super.achieveReason,
  }) : super(walletType: WalletTypeEnum.savings);

  /// Factory constructor for [SavingsWalletModel] from JSON
  factory SavingsWalletModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsWalletModelFromJson(json);

  /// Factory constructor for [SavingsWalletModel] from [BaseWalletModel]
  factory SavingsWalletModel.fromBaseWalletModel({
    required BaseWalletModel baseWalletModel,
    required double savingsGoal,
  }) {
    return SavingsWalletModel(
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
      savingsGoal: savingsGoal,
      description: baseWalletModel.description,
      archivedAt: baseWalletModel.archivedAt,
      achieveReason: baseWalletModel.achieveReason,
    );
  }

  /// Factory constructor for [SavingsWalletModel] from [Wallet]
  factory SavingsWalletModel.fromWallet({
    required Wallet wallet,
  }) {
    return SavingsWalletModel(
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
      savingsGoal: wallet.savingsWallets.first.savingsWalletSavingsGoal,
      createdAt: wallet.walletCreatedAt,
      updatedAt: wallet.walletUpdatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$SavingsWalletModelToJson(this);

  /// Creates a empty wallet model.
  static final empty = SavingsWalletModel(
    id: '',
    name: '',
    baseCurrency: CurrencyModel.empty,
    balance: 0,
    icon: const EmojiDataIcon(raw: '', emoji: ''),
    color: Colors.black,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    excludeFromTotal: false,
    isArchived: false,
    savingsGoal: 0,
  );

  /// Checks if the wallet is empty.
  bool get isEmpty => this == SavingsWalletModel.empty;

  /// The savings goal of the wallet
  final double savingsGoal;

  @override
  List<Object?> get props => [
        ...super.props,
        savingsGoal,
      ];
}
