// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      transactionType: $enumDecode(
        _$TransactionTypeEnumEnumMap,
        json['transactionType'],
      ),
      name: json['name'] as String,
      icon: CategoryModel._iconFromJson(json['icon'] as String),
      color: CategoryModel._colorFromJson(json['color'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      parentCategoryId: json['parentCategoryId'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryModelToJson(
  CategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentCategoryId': instance.parentCategoryId,
  'transactionType': _$TransactionTypeEnumEnumMap[instance.transactionType]!,
  'name': instance.name,
  'icon': CategoryModel._iconToJson(instance.icon),
  'color': CategoryModel._colorToJson(instance.color),
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'enabled': instance.enabled,
};

const _$TransactionTypeEnumEnumMap = {
  TransactionTypeEnum.expense: 'expense',
  TransactionTypeEnum.income: 'income',
  TransactionTypeEnum.transfer: 'transfer',
  TransactionTypeEnum.unknown: 'unknown',
};
