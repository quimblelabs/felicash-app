import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/enums/wallet_type.enum.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:uuid/uuid.dart';

///{@template wallet_model}
/// Wallet model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'wallets'),
)
// ignore: must_be_immutable
class Wallet extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro wallet_model}
  Wallet({
    required this.profile,
    required this.walletType,
    required this.name,
    required this.description,
    required this.baseCurrency,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    this.archived = false,
    this.archivedAt,
    this.archiveReason,
    this.excludeFromTotal = false,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the wallet
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Profile of the wallet
  /// This is the profile of the user who created the wallet
  @Supabase(
    foreignKey: 'user_id',
    name: 'user_id',
    fromGenerator:
        'await ProfileAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.profile.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Profile profile;

  /// Type of the wallet
  @Supabase(
    enumAsString: true,
    fromGenerator: 'WalletType.values.byName(%DATA_PROPERTY% as String)',
  )
  @Sqlite(enumAsString: true)
  final WalletType walletType;

  /// Name of the wallet
  final String name;

  /// Description of the wallet
  final String description;

  /// Base currency of the wallet
  final String baseCurrency;

  /// Current balance of the wallet
  final double balance;

  /// Timestamp when the wallet was created
  final DateTime createdAt;

  /// Timestamp when the wallet was last updated
  final DateTime updatedAt;

  /// Flag to exclude the wallet balance from the total
  final bool excludeFromTotal;

  /// Flag to mark the wallet as archived
  final bool archived;

  /// Timestamp when the wallet was archived
  final DateTime? archivedAt;

  /// Reason for archiving the wallet
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? archiveReason;

  /// User id of the wallet
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get userId => profile.id;

  @override
  List<Object?> get props {
    return [
      id,
      profile,
      walletType,
      name,
      description,
      baseCurrency,
      balance,
      createdAt,
      updatedAt,
      excludeFromTotal,
      archived,
      archivedAt,
      archiveReason,
    ];
  }
}
