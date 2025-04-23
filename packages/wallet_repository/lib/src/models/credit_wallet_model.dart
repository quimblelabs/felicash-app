import 'package:currency_repository/currency_repository.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

part 'credit_wallet_model.g.dart';

/// {@template credit_wallet_model}
/// Credit Wallet model
/// {@endtemplate}
@JsonSerializable(
  converters: [HexColorConverter(), RawIconDataConverter()],
)
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

  /// Factory constructor for [CreditWalletModel] from JSON
  factory CreditWalletModel.fromJson(Map<String, dynamic> json) =>
      _$CreditWalletModelFromJson(json);

  /// Factory constructor for [CreditWalletModel] from [BaseWalletModel]
  factory CreditWalletModel.fromBaseWalletModel({
    required BaseWalletModel baseWalletModel,
    required double creditLimit,
    required int stateDayOfMonth,
    required int paymentDueDayOfMonth,
  }) {
    return CreditWalletModel(
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
      creditLimit: creditLimit,
      stateDayOfMonth: stateDayOfMonth,
      paymentDueDayOfMonth: paymentDueDayOfMonth,
      description: baseWalletModel.description,
      archivedAt: baseWalletModel.archivedAt,
      achieveReason: baseWalletModel.achieveReason,
    );
  }

  /// Factory constructor for [CreditWalletModel] from [Wallet]
  factory CreditWalletModel.fromWallet({
    required Wallet wallet,
  }) {
    return CreditWalletModel(
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
      creditLimit: wallet.creditWallets.first.creditWalletCreditLimit,
      paymentDueDayOfMonth:
          wallet.creditWallets.first.creditWalletPaymentDueDayOfMonth,
      stateDayOfMonth: wallet.creditWallets.first.creditWalletStateDayOfMonth,
      createdAt: wallet.walletCreatedAt,
      updatedAt: wallet.walletUpdatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CreditWalletModelToJson(this);

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
    icon: const EmojiDataIcon(raw: '', emoji: ''),
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

  @override
  List<Object?> get props => [
        ...super.props,
        creditLimit,
        stateDayOfMonth,
        paymentDueDayOfMonth,
      ];
}
