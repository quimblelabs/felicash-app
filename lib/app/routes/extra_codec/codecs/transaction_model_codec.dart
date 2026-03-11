import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Codec for TransactionListFilter.
class TransactionModelCodec extends ExtraCodec<TransactionModel?> {
  const TransactionModelCodec();

  @override
  String get typeId => 'TransactionModel';

  @override
  Object? encode(TransactionModel? input) => input?.toJson();

  @override
  TransactionModel? decode(Object? input) {
    if (input == null) {
      return null;
    }
    if (input is! Map<String, dynamic>) {
      throw FormatException(
        'Expected Map<String, dynamic>, got \\${input.runtimeType}',
      );
    }
    return TransactionModel.fromJson(input);
  }
}
