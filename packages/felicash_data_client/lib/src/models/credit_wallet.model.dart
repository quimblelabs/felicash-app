import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/wallet.model.dart';

/// {@template credit_wallet_model}
/// Credit wallet model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'credit_wallets'),
)
// ignore: must_be_immutable
class CreditWallet extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro credit_wallet_model}
  CreditWallet({
    required this.wallet,
    required this.creditLimit,
    required this.stateDayOfMonth,
    required this.paymentDueDayOfMonth,
  });

  /// Wallet of the credit wallet which is relate to wallet table
  /// in database on wallet_id column
  @Supabase(
    foreignKey: 'wallet_id',
    fromGenerator:
        'await WalletAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
  )
  @Sqlite(onDeleteCascade: true)
  final Wallet wallet;

  /// Credit limit of the credit wallet
  /// This is the maximum amount of money that can be borrowed from the credit
  /// wallet
  final double creditLimit;

  /// Number of days after the statement date of the credit wallet
  /// when the payment is due
  final int stateDayOfMonth;

  /// Payment due day of month of the credit wallet
  /// This is the day of the month when the payment is due
  final int paymentDueDayOfMonth;

  /// Wallet id of the credit wallet
  /// This is the id of the wallet which is relate to wallet table
  /// in database on wallet_id column
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String get walletId => wallet.id;

  @override
  List<Object?> get props => [
    wallet,
    creditLimit,
    stateDayOfMonth,
    paymentDueDayOfMonth,
  ];
}
