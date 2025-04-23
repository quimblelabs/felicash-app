import 'package:ai_client/src/models/extracted_category.dart';
import 'package:ai_client/src/models/extracted_wallet.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extracted_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExtractedTransaction extends Equatable {
  const ExtractedTransaction({
    this.amount,
    this.notes,
    this.transactionDate,
    this.merchantName,
    this.merchantAddress,
    this.transactionType,
    this.category,
    this.wallet,
  });

  final double? amount;

  final String? notes;

  final DateTime? transactionDate;

  final String? merchantName;

  final String? merchantAddress;

  final String? transactionType;

  final ExtractedCategory? category;

  final ExtractedWallet? wallet;

  factory ExtractedTransaction.fromJson(Map<String, dynamic> json) =>
      _$ExtractedTransactionFromJson(json);

  @override
  List<Object?> get props => [
    amount,
    notes,
    transactionDate,
    merchantName,
    merchantAddress,
    transactionType,
    category,
    wallet,
  ];
}
