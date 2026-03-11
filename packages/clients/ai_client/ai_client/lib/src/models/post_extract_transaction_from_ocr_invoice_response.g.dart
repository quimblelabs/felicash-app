// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_extract_transaction_from_ocr_invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostExtractTransactionFromOCRInvoiceResponse
_$PostExtractTransactionFromOCRInvoiceResponseFromJson(
  Map<String, dynamic> json,
) => PostExtractTransactionFromOCRInvoiceResponse(
  output:
      json['output'] == null
          ? null
          : PostExtractTransactionFromOCRInvoiceOutput.fromJson(
            json['output'] as Map<String, dynamic>,
          ),
  startTime:
      json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
  executeTime: json['execute_time'] as String?,
);

PostExtractTransactionFromOCRInvoiceOutput
_$PostExtractTransactionFromOCRInvoiceOutputFromJson(
  Map<String, dynamic> json,
) => PostExtractTransactionFromOCRInvoiceOutput(
  responseText: json['response'] as String?,
  extractedTransactions:
      (json['transactions'] as List<dynamic>?)
          ?.map((e) => ExtractedTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
);
