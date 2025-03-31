import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:uuid/uuid.dart';

/// {@template savings_wallet_model}
/// Profile model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'merchants'),
)
// ignore: must_be_immutable
class Merchant extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro profile_model}
  Merchant({
    required this.profile,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.metadata,
    this.address,
    this.lat,
    this.lng,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the merchant
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Profile of the merchant
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

  /// Name of the merchant
  final String name;

  /// Address of the merchant
  final String? address;

  /// Lat of the merchant
  final double? lat;

  /// Lng of the merchant
  final double? lng;

  /// Metadata of the merchant
  @Supabase(fromGenerator: '%DATA_PROPERTY% as Map<String, dynamic>')
  @Sqlite(
    fromGenerator:
        'jsonDecode(%DATA_PROPERTY% as String) as Map<String, dynamic>',
  )
  final Map<String, dynamic>? metadata;

  /// Created at of the merchant
  final DateTime createdAt;

  /// Updated at of the merchant
  final DateTime updatedAt;

  /// User id of the merchant
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get userId => profile.id;

  @override
  List<Object?> get props => [
    id,
    profile,
    name,
    address,
    lat,
    lng,
    metadata,
    createdAt,
    updatedAt,
  ];
}
