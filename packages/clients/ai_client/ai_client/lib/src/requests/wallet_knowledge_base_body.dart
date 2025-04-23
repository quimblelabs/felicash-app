import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_knowledge_base_body.g.dart';

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class WalletKnowledgeBaseBody extends Equatable {
  const WalletKnowledgeBaseBody({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  Map<String, dynamic> toJson() => _$WalletKnowledgeBaseBodyToJson(this);

  @override
  List<Object?> get props => [id, name, description];
}
