import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

/// {@template wallet_failure}
/// Base failure class for wallet repository.
/// {@endtemplate}
abstract class WalletFailure with EquatableMixin implements Exception {
  /// {@macro wallet_failure}
  const WalletFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_wallets_failure}
/// Failure when fetching wallets.
/// {@endtemplate}
class GetWalletsFailure extends WalletFailure {
  /// {@macro get_wallets_failure}
  const GetWalletsFailure(super.error);
}

/// {@template get_wallet_by_id_failure}
/// Failure when fetching a wallet by id.
/// {@endtemplate}
class GetWalletByIdFailure extends WalletFailure {
  /// {@macro get_wallet_by_id_failure}
  const GetWalletByIdFailure(super.error);
}

/// {@template create_wallet_failure}
/// Failure when creating a wallet.
/// {@endtemplate}
class CreateWalletFailure extends WalletFailure {
  /// {@macro create_wallet_failure}
  const CreateWalletFailure(super.error);
}

/// {@template wallet_repository}
/// A wallet repository.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  const WalletRepository({
    required FelicashDataClient client,
  }) : _client = client;

  final FelicashDataClient _client;

  /// Fetches all wallets.
  ///
  /// Throws a [GetWalletsFailure] if an error occurs.
  Future<List<BaseWalletModel>> getWallets() async {
    try {
      //TODO: implement getWallets
      throw UnimplementedError();
    } on GetWalletsFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(GetWalletsFailure(e), stacktrace);
    }
  }

  /// Fetches a wallet by id.
  ///
  /// Throws a [GetWalletByIdFailure] if an error occurs.
  Future<BaseWalletModel?> getWalletById(String id) async {
    try {
      //TODO: implement getWalletById
      throw UnimplementedError();
    } on GetWalletByIdFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(GetWalletByIdFailure(e), stacktrace);
    }
  }

  /// Creates a wallet.
  ///
  /// Throws a [CreateWalletFailure] if an error occurs.
  Future<BaseWalletModel> createWallet(BaseWalletModel wallet) async {
    try {
      //TODO: implement createWallet
      throw UnimplementedError();
    } on CreateWalletFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(CreateWalletFailure(e), stacktrace);
    }
  }
}
