import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

import 'package:felicash_data_client/src/models/wallet.model.dart';

/// {@template credit_wallet_model}
/// Credit wallet model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'credit_wallets'),
)
class CreditWallet extends OfflineFirstWithSupabaseModel {
  CreditWallet({required this.wallet});
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
}
