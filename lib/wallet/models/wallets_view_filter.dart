import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

class WalletsViewFilter extends Equatable {
  const WalletsViewFilter({
    this.walletTypeEnum,
  });
  final WalletTypeEnum? walletTypeEnum;
  @override
  List<Object?> get props => [walletTypeEnum];

  WalletsViewFilter copyWith({
    ValueGetter<WalletTypeEnum?>? walletTypeEnum,
  }) {
    return WalletsViewFilter(
      walletTypeEnum:
          walletTypeEnum != null ? walletTypeEnum() : this.walletTypeEnum,
    );
  }
}

extension WalletsViewFilterX on WalletsViewFilter {
  bool apply(BaseWalletModel wallet) {
    if (walletTypeEnum != null) {
      if (wallet.walletType != walletTypeEnum) {
        return false;
      }
    }
    return true;
  }

  Iterable<BaseWalletModel> applyAll(
    Iterable<BaseWalletModel> wallets,
  ) {
    return wallets.where(apply);
  }
}
