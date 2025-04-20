import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'wallets_event.dart';
part 'wallets_state.dart';

class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  WalletsBloc({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(const WalletInitial()) {
    on<WalletsSubscriptionRequested>(_onWalledLoadActivated);
    on<WalletsSubscriptionRetry>(_onWalletsSubscriptionRetry);
  }

  final WalletRepository _walletRepository;

  Future<void> _onWalledLoadActivated(
    WalletsSubscriptionRequested event,
    Emitter<WalletsState> emit,
  ) async {
    emit(const WalletLoadInProgress());
    await emit.forEach<List<BaseWalletModel>>(
      _walletRepository.getWallets(
        event.query,
      ),
      onData: (wallets) => WalletLoadSuccess(wallets: wallets),
      onError: (error, stackTrace) => WalletLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }

  Future<void> _onWalletsSubscriptionRetry(
    WalletsSubscriptionRetry event,
    Emitter<WalletsState> emit,
  ) async {
    emit(const WalletLoadInProgress());
    await emit.forEach<List<BaseWalletModel>>(
      _walletRepository.getWallets(event.query),
      onData: (wallets) => WalletLoadSuccess(wallets: wallets),
      onError: (error, stackTrace) => WalletLoadFailure(
        error: error,
        previousQuery: event.query,
      ),
    );
  }
}
