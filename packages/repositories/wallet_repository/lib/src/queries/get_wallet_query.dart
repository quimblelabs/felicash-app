import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:shared_models/shared_models.dart';

/// {@template get_wallet_query}
/// A query to get a wallet.
/// {@endtemplate}
class GetWalletQuery extends BaseGetQuery {
  /// {@macro get_wallet_query}
  const GetWalletQuery({
    this.name,
    this.description,
    this.baseCurrency,
    this.minBalance,
    this.maxBalance,
    this.walletType,
    this.archived,
    super.pageIndex,
    super.pageSize,
    super.orderType,
    super.orderBy = WalletFields.walletCreatedAt,
  });

  /// The wallet type.
  final WalletTypeEnum? walletType;

  /// The name to search for.
  final String? name;

  /// The description to search for.
  final String? description;

  /// The base currency to search for.
  final String? baseCurrency;

  /// The minimum balance.
  final double? minBalance;

  /// The maximum balance.
  final double? maxBalance;

  /// The archived flag.
  final bool? archived;

  @override
  List<Object?> get props => [
        pageIndex,
        pageSize,
        name,
        description,
        baseCurrency,
        minBalance,
        maxBalance,
        walletType,
        archived,
      ];
}
