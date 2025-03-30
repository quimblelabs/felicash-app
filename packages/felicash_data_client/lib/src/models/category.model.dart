import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/enums/transaction_type.enum.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:uuid/uuid.dart';

/// {@template credit_wallet_model}
/// Category model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'categories'),
)
// ignore: must_be_immutable
class Category extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro category_model}
  Category({
    required this.profile,
    required this.transactionType,
    required this.name,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    this.parentCategoryId,
    this.icon,
    this.color,
    this.description,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the category
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Profile of the category
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

  /// Parent category of the category
  final String? parentCategoryId;

  /// Transaction type of the category
  @Supabase(
    enumAsString: true,
    fromGenerator: 'TransactionType.fromSupabase(%DATA_PROPERTY% as String)',
  )
  @Sqlite(enumAsString: true)
  final TransactionType transactionType;

  /// Name of the category of the category
  final String name;

  /// Icon of the category
  /// Reason for archiving the wallet
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? icon;

  /// Color of the category
  /// Reason for archiving the wallet
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? color;

  /// Description of the category
  /// Reason for archiving the wallet
  @Supabase(defaultValue: 'null')
  @Sqlite(defaultValue: 'null')
  final String? description;

  /// Enabled of the category
  final bool enabled;

  /// Created at of the category
  final DateTime createdAt;

  /// Updated at of the category
  final DateTime updatedAt;

  /// User id of the category
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get userId => profile.id;

  @override
  List<Object?> get props => [
    id,
    profile,
    parentCategoryId,
    transactionType,
    name,
    icon,
    color,
    description,
    enabled,
    createdAt,
    updatedAt,
  ];
}
