import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';

/// Codec for (DateTime?, DateTime?) DateRange.
class DateRangeCodec extends ExtraCodec<(DateTime?, DateTime?)> {
  const DateRangeCodec();

  @override
  String get typeId => 'DateRange';

  @override
  Object? encode((DateTime?, DateTime?) input) =>
      [input.$1?.toIso8601String(), input.$2?.toIso8601String()];

  @override
  (DateTime?, DateTime?) decode(Object? input) {
    if (input == null) {
      return (null, null);
    }
    if (input is! List<Object?>) {
      throw FormatException(
        'Expected List<Object?>, got \\${input.runtimeType}',
      );
    }
    final from = input[0] as String?;
    final to = input[1] as String?;
    return (
      from != null ? DateTime.parse(from) : null,
      to != null ? DateTime.parse(to) : null,
    );
  }
}
