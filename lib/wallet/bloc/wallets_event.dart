part of 'wallets_bloc.dart';

sealed class WalletsEvent extends Equatable {
  const WalletsEvent();

  @override
  List<Object> get props => [];
}

class WalletsSubscriptionRequested extends WalletsEvent {
  const WalletsSubscriptionRequested({
    required this.query,
  });

  final GetWalletQuery query;

  @override
  List<Object> get props => [query];
}

class WalletsSubscriptionRetry extends WalletsEvent {
  const WalletsSubscriptionRetry({
    required this.query,
  });

  final GetWalletQuery query;

  @override
  List<Object> get props => [query];
}
