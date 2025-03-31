import 'package:ai_client/src/requests/query_text_body.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_query_body.g.dart';

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PostQueryBody extends Equatable {
  const PostQueryBody({required this.queryText});

  final QueryTextBody queryText;

  Map<String, dynamic> toJson() => _$PostQueryBodyToJson(this);
  @override
  List<Object?> get props => [queryText];
}
