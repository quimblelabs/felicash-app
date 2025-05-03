import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_query_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PostQueryResponse extends Equatable {
  const PostQueryResponse({
    this.response,
    this.queryText,
    this.startTime,
    this.executeTime,
  });
  final PostQueryOutput? response;

  final String? queryText;

  final DateTime? startTime;

  final String? executeTime;

  factory PostQueryResponse.fromJson(Map<String, dynamic> json) =>
      _$PostQueryResponseFromJson(json);

  @override
  List<Object?> get props => [response, queryText, startTime, executeTime];
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PostQueryOutput extends Equatable {
  final String? text;

  const PostQueryOutput({this.text});

  factory PostQueryOutput.fromJson(Map<String, dynamic> json) =>
      _$PostQueryOutputFromJson(json);

  @override
  List<Object?> get props => [text];
}
