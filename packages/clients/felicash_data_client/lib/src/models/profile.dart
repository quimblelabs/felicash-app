import 'package:json_annotation/json_annotation.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

part 'profile.g.dart';

/// {@template profile_fields}
/// Profile fields
/// {@endtemplate}
typedef ProfileFields = _$ProfileJsonKeys;

/// {@template savings_wallet_model}
/// Profile model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
// ignore: must_be_immutable
class Profile {
  /// {@macro profile_model}
  Profile({required this.profileId, this.profileFcmToken}) : id = profileId;

  /// Creates a profile from a row.
  factory Profile.fromRow(sqlite.Row row) {
    return Profile(
      profileId: row[ProfileFields.profileId] as String,
      profileFcmToken: row[ProfileFields.profileFcmToken] as String?,
    );
  }

  /// Table name of the profile
  static const String tableName = 'profiles';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the profile
  final String profileId;

  /// Fcm token of the profile
  /// This is used to send push notifications to the user
  final String? profileFcmToken;

  /// Creates a copy of the wallet with the given fields replaced with the
  /// new values.
  Profile copyWith({String? profileId, String? profileFcmToken}) {
    return Profile(
      profileId: profileId ?? this.profileId,
      profileFcmToken: profileFcmToken ?? this.profileFcmToken,
    );
  }
}
