part of 'wallets_bloc.dart';

sealed class WalletsEvent extends Equatable {
  const WalletsEvent();

  @override
  List<Object> get props => [];
}

class WalletsWalletTypeChanged extends WalletsEvent {
  const WalletsWalletTypeChanged({
    required this.walletType,
  });
  final WalletTypeEnum walletType;

  @override
  List<Object> get props => [walletType];
}
