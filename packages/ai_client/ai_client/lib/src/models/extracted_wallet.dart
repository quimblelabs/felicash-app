import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extracted_wallet.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExtractedWallet extends Equatable {
  const ExtractedWallet({this.id, this.name, this.description});

  final String? id;

  final String? name;

  final String? description;

  factory ExtractedWallet.fromJson(Map<String, dynamic> json) =>
      _$ExtractedWalletFromJson(json);

  @override
  List<Object?> get props => [id, name, description];
}
