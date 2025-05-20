import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';

/// Codec for TransactionListFilter.
class TransactionListFilterCodec extends ExtraCodec<TransactionListFilter> {
  const TransactionListFilterCodec();

  @override
  String get typeId => 'TransactionListFilter';

  @override
  Object? encode(TransactionListFilter input) => input.toJson();

  @override
  TransactionListFilter decode(Object? input) {
    if (input == null) {
      return TransactionListFilter.empty;
    }
    if (input is! Map<String, dynamic>) {
      throw FormatException(
        'Expected Map<String, dynamic>, got \\${input.runtimeType}',
      );
    }
    return TransactionListFilter.fromJson(input);
  }
}
