import 'dart:convert';

import 'package:felicash/transaction/models/transaction_list_filter.dart';

class AppRouterExtraCodec extends Codec<Object?, Object?> {
  const AppRouterExtraCodec();

  @override
  Converter<Object?, Object?> get decoder {
    return const _AppRouterExtraCodecDecoder();
  }

  @override
  Converter<Object?, Object?> get encoder {
    return const _AppRouterExtraCodecEncoder();
  }
}

class _AppRouterExtraCodecDecoder extends Converter<Object?, Object?> {
  const _AppRouterExtraCodecDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'TransactionListFilter') {
      return TransactionListFilter.fromJson(
        inputAsList[1] as Map<String, dynamic>? ?? {},
      );
    }
    throw FormatException('Unable to parse input: $input');
  }
}

class _AppRouterExtraCodecEncoder extends Converter<Object?, Object?> {
  const _AppRouterExtraCodecEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    return switch (input) {
      TransactionListFilter _ => [
          'TransactionListFilter',
          input.toJson(),
        ],
      _ => throw FormatException('Cannot encode type ${input.runtimeType}'),
    };
  }
}
