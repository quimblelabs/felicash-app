import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/enums/recurrence_type.enum.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:uuid/uuid.dart';

/// {@template savings_wallet_model}
/// Recurrence model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'recurrences'),
)
// ignore: must_be_immutable
class Recurrence extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro recurrence_model}
  Recurrence({
    required this.profile,
    required this.cronString,
    required this.recurrenceType,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Id of the recurrence
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Profile of the recurrence
  /// This is the profile of the user who created the recurrence
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

  /// Cron string of the recurrence
  /// This is the cron string of the recurrence
  final String? cronString;

  /// Recurrence type of the recurrence
  /// This is the recurrence type of the recurrence
  @Supabase(
    enumAsString: true,
    fromGenerator: 'RecurrenceType.fromSupabase(%DATA_PROPERTY% as String)',
  )
  @Sqlite(enumAsString: true)
  final RecurrenceType recurrenceType;

  /// Description of the recurrence
  final String? description;

  /// Created at of the recurrence
  final DateTime createdAt;

  /// Updated at of the recurrence
  final DateTime updatedAt;

  /// User id of the recurrence
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String get userId => profile.id;

  @override
  List<Object?> get props => [
    id,
    profile,
    cronString,
    recurrenceType,
    createdAt,
    updatedAt,
  ];
}
