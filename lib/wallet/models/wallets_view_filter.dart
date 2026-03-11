import 'package:equatable/equatable.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

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
  bool apply(WalletViewModel walletViewModel) {
    final wallet = walletViewModel.wallet;
    if (walletTypeEnum != null) {
      if (wallet.walletType != walletTypeEnum) {
        return false;
      }
    }
    if (searchQuery != null) {
      final searchTerm = [wallet.name, wallet.description, wallet.currencyCode];
      if (!searchTerm.any(_matchSearchQuery)) {
        return false;
      }
    }
    return true;
  }

  Iterable<WalletViewModel> applyAll(
    Iterable<WalletViewModel> wallets,
  ) {
    return wallets.where(apply);
  }

  bool _matchSearchQuery(String? value) {
    if (searchQuery == null || value == null) {
      return false;
    }
    return value.toLowerCase().contains(searchQuery!.toLowerCase());
  }
}
