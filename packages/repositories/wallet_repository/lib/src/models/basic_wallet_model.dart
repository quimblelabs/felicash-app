import 'package:currency_repository/currency_repository.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

part 'basic_wallet_model.g.dart';

/// {@template basic_wallet_model}
/// Basic Wallet model
/// {@endtemplate}
@JsonSerializable(
  converters: [HexColorConverter(), RawIconDataConverter()],
)
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

  /// Factory constructor for [BasicWalletModel] from JSON
  factory BasicWalletModel.fromJson(Map<String, dynamic> json) =>
      _$BasicWalletModelFromJson(json);

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
  factory BasicWalletModel.fromWallet({required Wallet wallet}) {
    return BasicWalletModel(
      id: wallet.walletId,
      name: wallet.walletName,
      description: wallet.walletDescription,
      baseCurrency: CurrencyModel.fromCurrency(wallet.currencies.first),
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

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$BasicWalletModelToJson(this);

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

  BasicWalletModel copyWith({
    String? id,
    String? name,
    String? description,
    CurrencyModel? baseCurrency,
    double? balance,
    Color? color,
    RawIconData? icon,
    bool? excludeFromTotal,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
    String? achieveReason,
  }) {
    return BasicWalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      balance: balance ?? this.balance,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      excludeFromTotal: excludeFromTotal ?? this.excludeFromTotal,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      achieveReason: achieveReason ?? this.achieveReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Checks if the wallet is empty.
  bool get isEmpty => this == BasicWalletModel.empty;
}
