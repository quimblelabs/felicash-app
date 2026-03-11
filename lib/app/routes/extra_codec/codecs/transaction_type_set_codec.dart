import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';
import 'package:shared_models/shared_models.dart';

/// Codec for Set<TransactionTypeEnum>.
class TransactionTypeSetCodec extends ExtraCodec<Set<TransactionTypeEnum>> {
  const TransactionTypeSetCodec();

  @override
  String get typeId => 'TransactionTypeSet';

  @override
  Object? encode(Set<TransactionTypeEnum> input) =>
      input.map((e) => e.jsonKey).toList();

  @override
  Set<TransactionTypeEnum> decode(Object? input) {
    if (input == null) {
      return {};
    }
    if (input is! List<Object?>) {
      throw FormatException(
        'Expected List<Object?>, got \\${input.runtimeType}',
      );
    }
    return input
        .whereType<String>()
        .map(TransactionTypeEnum.fromJsonKey)
        .toSet();
  }
}
