// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionListFilter _$TransactionListFilterFromJson(
        Map<String, dynamic> json) =>
    _TransactionListFilter(
      searchKey: json['searchKey'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$TransactionTypeEnumEnumMap, e))
              .toSet() ??
          const {},
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => WalletViewModel.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      from:
          json['from'] == null ? null : DateTime.parse(json['from'] as String),
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$TransactionListFilterToJson(
        _TransactionListFilter instance) =>
    <String, dynamic>{
      'searchKey': instance.searchKey,
      'categories': instance.categories.toList(),
      'types':
          instance.types.map((e) => _$TransactionTypeEnumEnumMap[e]!).toList(),
      'wallets': instance.wallets.toList(),
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
    };

const _$TransactionTypeEnumEnumMap = {
  TransactionTypeEnum.expense: 'expense',
  TransactionTypeEnum.income: 'income',
  TransactionTypeEnum.transfer: 'transfer',
  TransactionTypeEnum.unknown: 'unknown',
};
