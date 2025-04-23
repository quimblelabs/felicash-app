import 'package:ai_client/src/requests/category_knowledge_base_body.dart';
import 'package:ai_client/src/requests/transaction_type_knowledge_base_body.dart';
import 'package:ai_client/src/requests/wallet_knowledge_base_body.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'knowledge_base_body.g.dart';

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class KnowledgeBaseBody extends Equatable {
  const KnowledgeBaseBody({
    this.categories,
    this.transactionTypes,
    this.wallets,
    required this.sourceWallet,
  });

  final List<CategoryKnowledgeBaseBody>? categories;
  final List<TransactionTypeKnowledgeBaseBody>? transactionTypes;
  final List<WalletKnowledgeBaseBody>? wallets;
  final WalletKnowledgeBaseBody sourceWallet;

  Map<String, dynamic> toJson() => _$KnowledgeBaseBodyToJson(this);

  @override
  List<Object?> get props => [
    categories,
    transactionTypes,
    wallets,
    sourceWallet,
  ];
}
