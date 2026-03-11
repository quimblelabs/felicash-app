// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_extract_transaction_from_text_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostExtractTransactionFromTextResponse
_$PostExtractTransactionFromTextResponseFromJson(Map<String, dynamic> json) =>
    PostExtractTransactionFromTextResponse(
      output:
          json['output'] == null
              ? null
              : PostExtractTransactionFromTextOutput.fromJson(
                json['output'] as Map<String, dynamic>,
              ),
      startTime:
          json['start_time'] == null
              ? null
              : DateTime.parse(json['start_time'] as String),
      executeTime: json['execute_time'] as String?,
    );

PostExtractTransactionFromTextOutput
_$PostExtractTransactionFromTextOutputFromJson(Map<String, dynamic> json) =>
    PostExtractTransactionFromTextOutput(
      responseText: json['response'] as String?,
      extractedTransactions:
          (json['transactions'] as List<dynamic>?)
              ?.map(
                (e) => ExtractedTransaction.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
