// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      wallet: BaseWalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      transactionType:
          $enumDecode(_$TransactionTypeEnumEnumMap, json['transactionType']),
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      imageAttachment: json['imageAttachment'] as String?,
      recurrence: json['recurrence'] == null
          ? null
          : RecurrenceModel.fromJson(
              json['recurrence'] as Map<String, dynamic>),
      transferWallet: json['transferWallet'] == null
          ? null
          : BaseWalletModel.fromJson(
              json['transferWallet'] as Map<String, dynamic>),
      transferTransaction: json['transferTransaction'] == null
          ? null
          : TransactionModel.fromJson(
              json['transferTransaction'] as Map<String, dynamic>),
      merchantId: json['merchantId'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet': instance.wallet,
      'transactionType':
          _$TransactionTypeEnumEnumMap[instance.transactionType]!,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'category': instance.category,
      'notes': instance.notes,
      'imageAttachment': instance.imageAttachment,
      'recurrence': instance.recurrence,
      'transferWallet': instance.transferWallet,
      'transferTransaction': instance.transferTransaction,
      'merchantId': instance.merchantId,
    };

const _$TransactionTypeEnumEnumMap = {
  TransactionTypeEnum.expense: 'expense',
  TransactionTypeEnum.income: 'income',
  TransactionTypeEnum.transfer: 'transfer',
  TransactionTypeEnum.unknown: 'unknown',
};
