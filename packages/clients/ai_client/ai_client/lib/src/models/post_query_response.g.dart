// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_query_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostQueryResponse _$PostQueryResponseFromJson(Map<String, dynamic> json) =>
    PostQueryResponse(
      response:
          json['response'] == null
              ? null
              : PostQueryOutput.fromJson(
                json['response'] as Map<String, dynamic>,
              ),
      queryText: json['query_text'] as String?,
      startTime:
          json['start_time'] == null
              ? null
              : DateTime.parse(json['start_time'] as String),
      executeTime: json['execute_time'] as String?,
    );

PostQueryOutput _$PostQueryOutputFromJson(Map<String, dynamic> json) =>
    PostQueryOutput(response: json['response'] as String?);
