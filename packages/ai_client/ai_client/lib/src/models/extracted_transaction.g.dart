// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtractedTransaction _$ExtractedTransactionFromJson(
  Map<String, dynamic> json,
) => ExtractedTransaction(
  amount: (json['amount'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  transactionDate:
      json['transaction_date'] == null
          ? null
          : DateTime.parse(json['transaction_date'] as String),
  merchantName: json['merchant_name'] as String?,
  merchantAddress: json['merchant_address'] as String?,
  transactionType: json['transaction_type'] as String?,
  category:
      json['category'] == null
          ? null
          : ExtractedCategory.fromJson(
            json['category'] as Map<String, dynamic>,
          ),
  wallet:
      json['wallet'] == null
          ? null
          : ExtractedWallet.fromJson(json['wallet'] as Map<String, dynamic>),
);
