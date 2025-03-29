import 'package:wallet_repository/src/enums/wallet_type_enum.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

/// {@template basic_wallet_model}
/// Basic Wallet model
/// {@endtemplate}
class BasicWalletModel extends BaseWalletModel {
  /// {@macro basic_wallet_model}
  const BasicWalletModel({
    required super.id,
    required super.name,
    required super.baseCurrency,
    required super.balance,
    required super.createdAt,
    required super.updatedAt,
    required super.excludeFromTotal,
    required super.isArchived,
    super.description,
    super.archivedAt,
    super.achieveReason,
  }) : super(walletType: WalletTypeEnum.basic);
}
