import 'package:ai_client/src/models/extracted_transaction.dart';
import 'package:ai_client/src/models/response_text.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_extract_transaction_from_text_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class PostExtractTransactionFromTextResponse extends Equatable {
  const PostExtractTransactionFromTextResponse({
    this.output,
    this.startTime,
    this.executeTime,
  });

  final PostExtractTransactionFromTextOutput? output;

  final DateTime? startTime;

  final String? executeTime;

  factory PostExtractTransactionFromTextResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PostExtractTransactionFromTextResponseFromJson(json);

  @override
  List<Object?> get props => [output, startTime, executeTime];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class PostExtractTransactionFromTextOutput extends Equatable {
  const PostExtractTransactionFromTextOutput({
    this.responseText,
    this.extractedTransactions,
  });

  @JsonKey(name: 'response')
  final ResponseText? responseText;

  @JsonKey(name: 'transactions')
  final List<ExtractedTransaction>? extractedTransactions;

  factory PostExtractTransactionFromTextOutput.fromJson(
    Map<String, dynamic> json,
  ) => _$PostExtractTransactionFromTextOutputFromJson(json);

  @override
  List<Object?> get props => [responseText, extractedTransactions];
}
