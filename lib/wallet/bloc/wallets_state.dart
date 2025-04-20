part of 'wallets_bloc.dart';

sealed class WalletsState extends Equatable {
  const WalletsState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletsState {
  const WalletInitial();

  @override
  List<Object> get props => [];
}

final class WalletLoadInProgress extends WalletsState {
  const WalletLoadInProgress({
    this.wallets = const [],
    this.messageText = 'Loading wallets...',
  });
  final List<BaseWalletModel> wallets;
  final String messageText;

  @override
  List<Object> get props => [wallets, messageText];
}

final class WalletLoadSuccess extends WalletsState {
  const WalletLoadSuccess({
    this.wallets = const [],
  });
  final List<BaseWalletModel> wallets;

  @override
  List<Object> get props => [wallets];
}

final class WalletLoadFailure extends WalletsState {
  const WalletLoadFailure({
    required this.error,
    required this.previousQuery,
    this.messageText = 'Error when load wallets',
  });
  final String messageText;

  final Object error;
  final GetWalletQuery previousQuery;

  @override
  List<Object> get props => [messageText, error, previousQuery];
}
