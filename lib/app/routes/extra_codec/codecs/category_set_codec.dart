import 'package:category_repository/category_repository.dart';
import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';

/// Codec for Set<CategoryModel>.
class CategorySetCodec extends ExtraCodec<Set<CategoryModel>> {
  const CategorySetCodec();

  @override
  String get typeId => 'CategorySet';

  @override
  Object? encode(Set<CategoryModel> input) =>
      input.map((e) => e.toJson()).toList();

  @override
  Set<CategoryModel> decode(Object? input) {
    if (input == null) {
      return {};
    }
    if (input is! List<Object?>) {
      throw FormatException(
        'Expected List<Object?>, got \\${input.runtimeType}',
      );
    }
    return input
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toSet();
  }
}
