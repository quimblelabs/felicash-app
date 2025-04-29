import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

class WalletsViewFilter extends Equatable {
  const WalletsViewFilter({
    this.searchQuery,
    this.walletTypeEnum,
  });

  final String? searchQuery;
  final WalletTypeEnum? walletTypeEnum;
  @override
  List<Object?> get props => [walletTypeEnum];

  WalletsViewFilter copyWith({
    ValueGetter<String?>? searchQuery,
    ValueGetter<WalletTypeEnum?>? walletTypeEnum,
  }) {
    return WalletsViewFilter(
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
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
    if (searchQuery != null) {
      if (!wallet.name.toLowerCase().contains(searchQuery!.toLowerCase())) {
        return false;
      }
      if (wallet.description != null &&
          !wallet.description!
              .toLowerCase()
              .contains(searchQuery!.toLowerCase())) {
        return false;
      }
      if (wallet.currencyCode.code
          .toLowerCase()
          .contains(searchQuery!.toLowerCase())) {
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
