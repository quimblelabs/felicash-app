import 'package:wallet_repository/src/enums/wallet_type_enum.dart';
import 'package:wallet_repository/src/models/base/base_wallet_model.dart';

/// {@template savings_walllet_model}
/// Savings Walllet Model
/// {@endtemplate}
class SavingsWallletModel extends BaseWalletModel {
  /// {@macro savings_walllet_model}
  const SavingsWallletModel({
    required super.id,
    required super.name,
    required super.baseCurrency,
    required super.balance,
    required super.icon,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    required super.excludeFromTotal,
    required super.isArchived,
    super.description,
    super.archivedAt,
    super.achieveReason,
  }) : super(walletType: WalletTypeEnum.savings);
}
