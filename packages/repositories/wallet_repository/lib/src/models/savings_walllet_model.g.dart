// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_walllet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsWalletModel _$SavingsWalletModelFromJson(Map<String, dynamic> json) =>
    SavingsWalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      baseCurrency:
          CurrencyModel.fromJson(json['baseCurrency'] as Map<String, dynamic>),
      balance: (json['balance'] as num).toDouble(),
      icon: const RawIconDataConverter().fromJson(json['icon'] as String),
      color: const HexColorConverter().fromJson(json['color'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      excludeFromTotal: json['excludeFromTotal'] as bool,
      isArchived: json['isArchived'] as bool,
      savingsGoal: (json['savingsGoal'] as num).toDouble(),
      description: json['description'] as String?,
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      achieveReason: json['achieveReason'] as String?,
    );

Map<String, dynamic> _$SavingsWalletModelToJson(SavingsWalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'baseCurrency': instance.baseCurrency,
      'balance': instance.balance,
      'icon': const RawIconDataConverter().toJson(instance.icon),
      'color': const HexColorConverter().toJson(instance.color),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'excludeFromTotal': instance.excludeFromTotal,
      'isArchived': instance.isArchived,
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'achieveReason': instance.achieveReason,
      'savingsGoal': instance.savingsGoal,
    };
