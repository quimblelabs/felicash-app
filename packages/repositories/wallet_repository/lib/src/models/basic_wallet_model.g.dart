// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicWalletModel _$BasicWalletModelFromJson(Map<String, dynamic> json) =>
    BasicWalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currencyCode: json['currencyCode'] as String,
      balance: (json['balance'] as num).toDouble(),
      color: const HexColorConverter().fromJson(json['color'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      excludeFromTotal: json['excludeFromTotal'] as bool,
      isArchived: json['isArchived'] as bool,
      icon: const RawIconDataConverter().fromJson(json['icon'] as String),
      description: json['description'] as String?,
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      achieveReason: json['achieveReason'] as String?,
    );

Map<String, dynamic> _$BasicWalletModelToJson(BasicWalletModel instance) =>
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
    };
