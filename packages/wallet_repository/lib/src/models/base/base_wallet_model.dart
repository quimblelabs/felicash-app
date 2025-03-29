// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:wallet_repository/src/enums/wallet_type_enum.dart';

abstract class BaseWalletModel extends Equatable {
  const BaseWalletModel({
    required this.id,
    required this.name,
    required this.walletType,
    required this.baseCurrency,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    required this.excludeFromTotal,
    required this.isArchived,
    this.description,
    this.archivedAt,
    this.achieveReason,
  });

  final String id;
  final String name;
  final String? description;
  final WalletTypeEnum walletType;
  final CurrencyModel baseCurrency;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool excludeFromTotal;
  final bool isArchived;
  final DateTime? archivedAt;
  final String? achieveReason;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      walletType,
      baseCurrency,
      balance,
      createdAt,
      updatedAt,
      excludeFromTotal,
      isArchived,
      archivedAt,
      achieveReason,
    ];
  }
}
