import 'dart:convert';

import 'package:category_repository/category_repository.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

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
    if (inputAsList[0] == 'CategorySet') {
      final list = inputAsList[1] as List<Object?>?;
      if (list == null) {
        return null;
      }
      final result = <CategoryModel>[];
      for (final e in list) {
        if (e == null) {
          throw FormatException('Unable to parse input: $input');
        }
        result.add(CategoryModel.fromJson(e as Map<String, dynamic>));
      }
      return result;
    }
    if (inputAsList[0] == 'TransactionTypeSet') {
      final list = inputAsList[1] as List<Object?>?;
      if (list == null) {
        return null;
      }
      final result = <TransactionTypeEnum>{};
      for (final e in list) {
        if (e == null) {
          throw FormatException('Unable to parse input: $input');
        }
        result.add(TransactionTypeEnum.fromJsonKey(e as String));
      }
      return result;
    }
    if (inputAsList[0] == 'DateRange') {
      final from = inputAsList[1] as String?;
      final to = inputAsList[2] as String?;
      return (
        from != null ? DateTime.parse(from) : null,
        to != null ? DateTime.parse(to) : null,
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
      Set<CategoryModel> _ => [
          'CategorySet',
          input.map((e) => e.toJson()).toList(),
        ],
      Set<TransactionTypeEnum> _ => [
          'TransactionTypeSet',
          input.map((e) => e.jsonKey).toList(),
        ],
      Set<WalletViewModel> _ => [
          'WalletSet',
          input.map((e) => e.toJson()).toList(),
        ],
      (DateTime?, DateTime?) _ => [
          'DateRange',
          input.$1?.toIso8601String(),
          input.$2?.toIso8601String(),
        ],
      _ => throw FormatException('Cannot encode type ${input.runtimeType}'),
    };
  }
}
