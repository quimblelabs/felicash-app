// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditWalletModel _$CreditWalletModelFromJson(Map<String, dynamic> json) =>
    CreditWalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currencyCode: json['currencyCode'] as String,
      balance: (json['balance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      icon: const RawIconDataConverter().fromJson(json['icon'] as String),
      color: const HexColorConverter().fromJson(json['color'] as String),
      excludeFromTotal: json['excludeFromTotal'] as bool,
      isArchived: json['isArchived'] as bool,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      stateDayOfMonth: (json['stateDayOfMonth'] as num).toInt(),
      paymentDueDayOfMonth: (json['paymentDueDayOfMonth'] as num).toInt(),
      description: json['description'] as String?,
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      achieveReason: json['achieveReason'] as String?,
    );

Map<String, dynamic> _$CreditWalletModelToJson(CreditWalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'currencyCode': instance.currencyCode,
      'balance': instance.balance,
      'icon': const RawIconDataConverter().toJson(instance.icon),
      'color': const HexColorConverter().toJson(instance.color),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'excludeFromTotal': instance.excludeFromTotal,
      'isArchived': instance.isArchived,
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'achieveReason': instance.achieveReason,
      'creditLimit': instance.creditLimit,
      'stateDayOfMonth': instance.stateDayOfMonth,
      'paymentDueDayOfMonth': instance.paymentDueDayOfMonth,
    };
