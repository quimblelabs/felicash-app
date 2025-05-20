import 'dart:convert';
import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/category_set_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/date_range_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/transaction_list_filter_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/transaction_model_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/transaction_type_set_codec.dart';
import 'package:felicash/app/routes/extra_codec/codecs/wallet_set_codec.dart';

/// Codec for serializing/deserializing complex objects as GoRouter extras.
class AppRouterExtraCodec extends Codec<Object?, Object?> {
  const AppRouterExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const AppRouterExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const AppRouterExtraEncoder();
}

/// Registry of codecs for supported types.
class ExtraCodecRegistry {
  static const _codecs = <String, ExtraCodec<dynamic>>{
    'TransactionModel': TransactionModelCodec(),
    'TransactionListFilter': TransactionListFilterCodec(),
    'CategorySet': CategorySetCodec(),
    'TransactionTypeSet': TransactionTypeSetCodec(),
    'WalletSet': WalletSetCodec(),
    'DateRange': DateRangeCodec(),
  };

  static ExtraCodec<dynamic>? getCodec(String typeId) => _codecs[typeId];
}

/// Decoder for router extras.
class AppRouterExtraDecoder extends Converter<Object?, Object?> {
  const AppRouterExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    if (input is! List<Object?>) {
      throw FormatException('Expected a list, got ${input.runtimeType}');
    }

    final typeId = input[0] as String?;
    final data = input[1];

    if (typeId == null) {
      throw FormatException('Missing type identifier in input: $input');
    }

    final codec = ExtraCodecRegistry.getCodec(typeId);
    if (codec == null) {
      throw FormatException('No codec found for type: $typeId');
    }

    return codec.decode(data);
  }
}

/// Encoder for router extras.
class AppRouterExtraEncoder extends Converter<Object?, Object?> {
  const AppRouterExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    for (final codec in ExtraCodecRegistry._codecs.values) {
      if (codec.encode(input) != null) {
        return [codec.typeId, codec.encode(input)];
      }
    }

    throw FormatException('Cannot encode type ${input.runtimeType}');
  }
}
