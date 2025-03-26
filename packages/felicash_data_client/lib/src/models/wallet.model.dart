import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// Type of wallet

enum WalletType {
  /// Basic wallet, for general use
  basic,

  /// Credit card wallet, for credit card payments or account payments that
  /// have a credit limit
  credit,

  /// Savings wallet, for savings accounts
  savings;

  factory WalletType.fromRest(String direction) {
    return WalletType.values.firstWhere(
      (e) => e.name == direction,
      orElse: () => WalletType.basic,
    );
  }

  /// Convert to sqlite value
  int toSqlite() => WalletType.values.indexOf(this);
}

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
    required this.userId,
    required this.walletType,
    required this.name,
    required this.description,
    required this.baseCurrency,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    String? id,
    this.archived = false,
    this.archivedAt,
    this.archiveReason,
    this.excludeFromTotal = false,
  }) : id = id ?? const Uuid().v4();

  /// Id of the wallet
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Id of the user who owns the wallet
  final String userId;

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

  //   Table wallets {
  //   id UUID [pk, note: 'Primary key for the wallet']
  //   user_id UUID [not null, note: 'Reference to the user who owns the wallet']
  //   wallet_type WALLET_TYPE [not null, note: 'Type of the wallet']
  //   name VARCHAR(100) [not null, note: 'Name of the wallet']
  //   description TEXT [note: 'Description of the wallet']
  //   base_currency VARCHAR(10) [not null, note: 'Base currency of the wallet']
  //   balance NUMERIC(15, 2) [not null, default: 0, note: 'Current balance of the wallet']
  //   created_at TIMESTAMP [default: `now()`, note: 'Timestamp when the wallet was created']
  //   updated_at TIMESTAMP [default: `now()`, note: 'Timestamp when the wallet was last updated']
  //   exclude_from_total BOOLEAN [default: false, note: 'Flag to exclude the wallet balance from the total']
  //   archived BOOLEAN [default: false, note: 'Flag to mark the wallet as archived']
  //   archived_at TIMESTAMP [null, note: 'Timestamp when the wallet was archived']
  //   archive_reason TEXT [null, note: 'Reason for archiving the wallet']
  //   Note: 'Stores common wallet information.'
  // }

  /// Flag to exclude the wallet balance from the total
  bool excludeFromTotal;

  /// Flag to mark the wallet as archived
  bool archived;

  /// Timestamp when the wallet was archived
  DateTime? archivedAt;

  /// Reason for archiving the wallet
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  String? archiveReason;
  @override
  List<Object?> get props {
    return [
      id,
      userId,
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
