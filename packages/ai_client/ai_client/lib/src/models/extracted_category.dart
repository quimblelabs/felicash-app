import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'extracted_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExtractedCategory extends Equatable {
  const ExtractedCategory({this.id, this.name, this.description});

  final String? id;

  final String? name;

  final String? description;

  factory ExtractedCategory.fromJson(Map<String, dynamic> json) =>
      _$ExtractedCategoryFromJson(json);

  @override
  List<Object?> get props => [id, name, description];
}
