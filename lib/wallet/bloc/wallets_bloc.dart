import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'wallets_event.dart';
part 'wallets_state.dart';

class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  WalletsBloc({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(const WalletInitial()) {
    on<WalletsWalletTypeChanged>(_onWalletTypeChanged);
  }

  final WalletRepository _walletRepository;

  Future<void> _onWalletTypeChanged(
    WalletsWalletTypeChanged event,
    Emitter<WalletsState> emit,
  ) async {
    emit(const WalletLoadInProgress());
    try {
      final wallets = await _walletRepository.getWallets(
        GetWalletQuery(
          walletType: event.walletType,
        ),
      );
      emit(WalletLoadSuccess(wallets: wallets));
    } catch (e, _) {
      emit(
        const WalletLoadFailure(),
      );
    }
  }
}
