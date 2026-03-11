// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletViewModel _$WalletViewModelFromJson(Map<String, dynamic> json) =>
    _WalletViewModel(
      wallet: BaseWalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      currency:
          CurrencyModel.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletViewModelToJson(_WalletViewModel instance) =>
    <String, dynamic>{
      'wallet': instance.wallet,
      'currency': instance.currency,
    };
