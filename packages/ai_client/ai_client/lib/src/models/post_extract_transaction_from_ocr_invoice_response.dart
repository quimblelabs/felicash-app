import 'package:ai_client/src/models/response_text.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'extracted_transaction.dart';

part 'post_extract_transaction_from_ocr_invoice_response.g.dart';

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PostExtractTransactionFromOCRInvoiceResponse extends Equatable {
  const PostExtractTransactionFromOCRInvoiceResponse({
    this.output,
    this.startTime,
    this.executeTime,
  });

  final PostExtractTransactionFromOCRInvoiceOutput? output;

  final DateTime? startTime;

  final String? executeTime;

  factory PostExtractTransactionFromOCRInvoiceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PostExtractTransactionFromOCRInvoiceResponseFromJson(json);

  @override
  List<Object?> get props => [output, startTime, executeTime];
}

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PostExtractTransactionFromOCRInvoiceOutput extends Equatable {
  const PostExtractTransactionFromOCRInvoiceOutput({
    this.responseText,
    this.extractedTransactions,
  });

  @JsonKey(name: 'response')
  final ResponseText? responseText;

  @JsonKey(name: 'transactions')
  final List<ExtractedTransaction>? extractedTransactions;

  factory PostExtractTransactionFromOCRInvoiceOutput.fromJson(
    Map<String, dynamic> json,
  ) => _$PostExtractTransactionFromOCRInvoiceOutputFromJson(json);

  @override
  List<Object?> get props => [responseText, extractedTransactions];
}
