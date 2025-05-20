import 'package:felicash/app/routes/extra_codec/codecs/_extra_codec.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';

/// Codec for Set<WalletViewModel>.
class WalletSetCodec extends ExtraCodec<Set<WalletViewModel>> {
  const WalletSetCodec();

  @override
  String get typeId => 'WalletSet';

  @override
  Object? encode(Set<WalletViewModel> input) =>
      input.map((e) => e.toJson()).toList();

  @override
  Set<WalletViewModel> decode(Object? input) {
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
        .map(WalletViewModel.fromJson)
        .toSet();
  }
}
