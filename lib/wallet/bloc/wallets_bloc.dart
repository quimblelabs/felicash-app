import 'package:bloc/bloc.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'wallets_event.dart';
part 'wallets_state.dart';

class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  WalletsBloc({
    required CurrencyRepository currencyRepository,
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        _currencyRepository = currencyRepository,
        super(const WalletInitial()) {
    on<WalletsSubscriptionRequested>(_onWalledLoadActivated);
  }

  final WalletRepository _walletRepository;
  final CurrencyRepository _currencyRepository;

  Future<void> _onWalledLoadActivated(
    WalletsSubscriptionRequested event,
    Emitter<WalletsState> emit,
  ) async {
    emit(const WalletLoadInProgress());
    try {
      final currencies = await _currencyRepository.getCurrencies();
      await emit.forEach<List<BaseWalletModel>>(
        _walletRepository.getWalletsStream(
          event.query,
        ),
        onData: (wallets) {
          final walletViewModels = wallets.map(
            (wallet) => WalletViewModel(
              wallet: wallet,
              currency: currencies.firstWhere(
                (currency) => currency.code == wallet.currencyCode,
              ),
            ),
          );
          return WalletLoadSuccess(wallets: walletViewModels.toList());
        },
        onError: (error, stackTrace) => WalletLoadFailure(
          error: error,
          previousQuery: event.query,
        ),
      );
    } catch (e) {
      emit(WalletLoadFailure(error: e, previousQuery: event.query));
    }
  }
}
