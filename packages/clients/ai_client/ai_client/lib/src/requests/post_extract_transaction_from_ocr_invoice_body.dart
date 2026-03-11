import 'package:ai_client/src/requests/knowledge_base_body.dart';
import 'package:ai_client/src/requests/query_text_body.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_extract_transaction_from_ocr_invoice_body.g.dart';

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PostExtractTransactionFromOCRInvoiceBody extends Equatable {
  final QueryTextBody queryText;

  final KnowledgeBaseBody knowledgeBase;

  const PostExtractTransactionFromOCRInvoiceBody({
    required this.queryText,
    required this.knowledgeBase,
  });

  Map<String, dynamic> toJson() =>
      _$PostExtractTransactionFromOCRInvoiceBodyToJson(this);

  @override
  List<Object?> get props => [queryText, knowledgeBase];
}
