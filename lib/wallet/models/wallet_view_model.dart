import 'package:currency_repository/currency_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'wallet_view_model.freezed.dart';
part 'wallet_view_model.g.dart';

@freezed
abstract class WalletViewModel with _$WalletViewModel {
  const factory WalletViewModel({
    required BaseWalletModel wallet,
    required CurrencyModel currency,
  }) = _WalletViewModel;

  factory WalletViewModel.fromJson(Map<String, dynamic> json) =>
      _$WalletViewModelFromJson(json);
}
