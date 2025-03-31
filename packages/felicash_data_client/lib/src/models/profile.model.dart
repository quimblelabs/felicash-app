import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// {@template savings_wallet_model}
/// Profile model
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'profiles'),
)
// ignore: must_be_immutable
class Profile extends OfflineFirstWithSupabaseModel with EquatableMixin {
  /// {@macro profile_model}
  Profile({String? id, this.fcmToken}) : id = id ?? const Uuid().v4();

  /// Id of the profile
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Fcm token of the profile
  /// This is used to send push notifications to the user
  final String? fcmToken;

  @override
  List<Object?> get props => [id, fcmToken];
}
