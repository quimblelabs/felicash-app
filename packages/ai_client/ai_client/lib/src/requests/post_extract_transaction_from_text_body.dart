import 'package:ai_client/src/requests/knowledge_base_body.dart';
import 'package:ai_client/src/requests/query_text_body.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_extract_transaction_from_text_body.g.dart';

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PostExtractTransactionFromTextBody extends Equatable {
  final QueryTextBody queryText;

  final KnowledgeBaseBody knowledgeBase;

  const PostExtractTransactionFromTextBody({
    required this.queryText,
    required this.knowledgeBase,
  });

  Map<String, dynamic> toJson() =>
      _$PostExtractTransactionFromTextBodyToJson(this);

  @override
  List<Object?> get props => [queryText, knowledgeBase];
}
