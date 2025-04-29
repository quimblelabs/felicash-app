import 'package:felicash_data_client/src/enums/wallet_type.dart';
import 'package:felicash_data_client/src/models/credit_wallet.dart';
import 'package:felicash_data_client/src/models/profile.dart';
import 'package:felicash_data_client/src/models/saving_wallet.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

part 'wallet.g.dart';

/// {@template wallet_fields}
/// Wallet fields
/// {@endtemplate}
typedef WalletFields = _$WalletJsonKeys;

///{@template wallet_model}
/// Wallet model
/// {@endtemplate}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Wallet {
  /// {@macro wallet_model}
  const Wallet({
    required this.walletId,
    required this.walletWalletType,
    required this.walletName,
    required this.walletDescription,
    required this.walletBalance,
    required this.walletCreatedAt,
    required this.walletUpdatedAt,
    required this.walletExcludeFromTotal,
    required this.walletArchived,
    required this.walletUserId,
    required this.walletCurrencyCode,
    this.walletIcon,
    this.walletColor,
    this.walletArchivedAt,
    this.walletArchiveReason,
    this.profiles = const [],
    this.creditWallets = const [],
    this.savingsWallets = const [],
  }) : id = walletId;

  /// Creates a wallet from a row.
  factory Wallet.fromRow(sqlite.Row row) {
    return Wallet(
      walletId: row[WalletFields.walletId] as String,
      walletWalletType: WalletType.values.byName(
        row[WalletFields.walletWalletType] as String,
      ),
      walletName: row[WalletFields.walletName] as String,
      walletDescription: row[WalletFields.walletDescription] as String,
      walletBalance: row[WalletFields.walletBalance] as double,
      walletCreatedAt: DateTime.parse(
        row[WalletFields.walletCreatedAt] as String,
      ),
      walletUpdatedAt: DateTime.parse(
        row[WalletFields.walletUpdatedAt] as String,
      ),
      walletExcludeFromTotal: row[WalletFields.walletExcludeFromTotal] == 1,
      walletArchived: row[WalletFields.walletArchived] == 1,
      walletUserId: row[WalletFields.walletUserId] as String,
      walletCurrencyCode: row[WalletFields.walletCurrencyCode] as String,
      walletIcon: row[WalletFields.walletIcon] as String?,
      walletColor: row[WalletFields.walletColor] as String?,
      walletArchivedAt:
          row[WalletFields.walletArchivedAt] == null
              ? null
              : DateTime.parse(row[WalletFields.walletArchivedAt] as String),
      walletArchiveReason: row[WalletFields.walletArchiveReason] as String?,
      profiles: [],
      creditWallets: [],
      savingsWallets: [],
    );
  }

  /// Table name of the wallet
  static const String tableName = 'wallets';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the wallet
  final String walletId;

  /// Type of the wallet
  final WalletType walletWalletType;

  /// Name of the wallet
  final String walletName;

  /// Description of the wallet
  final String walletDescription;

  /// Current balance of the wallet
  final double walletBalance;

  /// Icon of the wallet
  final String? walletIcon;

  /// Color of the wallet
  final String? walletColor;

  /// Timestamp when the wallet was created
  final DateTime walletCreatedAt;

  /// Timestamp when the wallet was last updated
  final DateTime walletUpdatedAt;

  /// Flag to exclude the wallet balance from the total
  final bool walletExcludeFromTotal;

  /// Flag to mark the wallet as archived
  final bool walletArchived;

  /// Timestamp when the wallet was archived
  final DateTime? walletArchivedAt;

  /// Reason for archiving the wallet
  final String? walletArchiveReason;

  /// Wallet user id of the wallet which is relate to profile table
  final String walletUserId;

  /// Profiles of the wallet
  final List<Profile> profiles;

  /// Credit wallets information for the wallet
  final List<CreditWallet> creditWallets;

  /// Savings wallets information for the wallet
  final List<SavingsWallet> savingsWallets;

  /// Wallet base currency of the wallet
  final String walletCurrencyCode;

  /// Creates a copy of the wallet with the given fields replaced with the
  /// new values.
  Wallet copyWith({
    String? walletId,
    WalletType? walletWalletType,
    String? walletName,
    String? walletDescription,
    double? walletBalance,
    String? walletIcon,
    String? walletColor,
    DateTime? walletCreatedAt,
    DateTime? walletUpdatedAt,
    bool? walletExcludeFromTotal,
    bool? walletArchived,
    DateTime? walletArchivedAt,
    String? walletArchiveReason,
    String? walletUserId,
    List<Profile>? profiles,
    List<CreditWallet>? creditWallets,
    List<SavingsWallet>? savingsWallets,
    String? walletCurrencyCode,
  }) {
    return Wallet(
      walletId: walletId ?? this.walletId,
      walletWalletType: walletWalletType ?? this.walletWalletType,
      walletName: walletName ?? this.walletName,
      walletDescription: walletDescription ?? this.walletDescription,
      walletBalance: walletBalance ?? this.walletBalance,
      walletIcon: walletIcon ?? this.walletIcon,
      walletColor: walletColor ?? this.walletColor,
      walletCreatedAt: walletCreatedAt ?? this.walletCreatedAt,
      walletUpdatedAt: walletUpdatedAt ?? this.walletUpdatedAt,
      walletExcludeFromTotal:
          walletExcludeFromTotal ?? this.walletExcludeFromTotal,
      walletArchived: walletArchived ?? this.walletArchived,
      walletArchivedAt: walletArchivedAt ?? this.walletArchivedAt,
      walletArchiveReason: walletArchiveReason ?? this.walletArchiveReason,
      walletUserId: walletUserId ?? this.walletUserId,
      profiles: profiles ?? this.profiles,
      creditWallets: creditWallets ?? this.creditWallets,
      savingsWallets: savingsWallets ?? this.savingsWallets,
      walletCurrencyCode: walletCurrencyCode ?? this.walletCurrencyCode,
    );
  }
}
