import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/wallet.model.dart';

/// {@template savings_wallet_model}
/// Savings wallet model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'savings_wallets'),
)
// ignore: must_be_immutable
class SavingsWallet extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro savings_wallet_model}
  SavingsWallet({required this.wallet, required this.savingsGoal});

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

  /// Savings goal of the savings wallet
  final double savingsGoal;

  /// Wallet id of the savings wallet
  /// This is the id of the wallet which is relate to wallet table
  /// in database on wallet_id column
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String get walletId => wallet.id;

  @override
  List<Object?> get props => [walletId, savingsGoal];
}
