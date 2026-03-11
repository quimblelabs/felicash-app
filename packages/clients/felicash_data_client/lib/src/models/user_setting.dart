import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting.g.dart';

/// {@template user_setting_fields}
/// User setting fields
/// {@endtemplate}
typedef UserSettingFields = _$UserSettingJsonKeys;

/// {@template user_setting}
/// A user setting
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class UserSetting {
  /// {@macro user_setting}
  const UserSetting({
    required this.userSettingId,
    required this.userSettingBaseCurrencyCode,
    required this.userSettingLanguageCode,
    required this.userSettingDateFormat,
    required this.userSettingDefaultWallet,
    required this.userSettingCreatedAt,
    required this.userSettingUpdatedAt,
    required this.userSettingTheme,
    required this.userSettingMonetaryFormat,
    required this.userSettingUserId,
  }) : id = userSettingId;

  ///  Factory constructor for [UserSetting] from [SqliteRow]
  factory UserSetting.fromRow(SqliteRow row) {
    return UserSetting(
      userSettingId: row[UserSettingFields.userSettingId] as String,
      userSettingBaseCurrencyCode:
          row[UserSettingFields.userSettingBaseCurrencyCode] as String?,
      userSettingLanguageCode:
          row[UserSettingFields.userSettingLanguageCode] as String,
      userSettingDateFormat:
          row[UserSettingFields.userSettingDateFormat] as String,
      userSettingDefaultWallet:
          row[UserSettingFields.userSettingDefaultWallet] as String?,
      userSettingCreatedAt: DateTime.parse(
        row[UserSettingFields.userSettingCreatedAt] as String,
      ),
      userSettingUpdatedAt: DateTime.parse(
        row[UserSettingFields.userSettingUpdatedAt] as String,
      ),
      userSettingTheme: row[UserSettingFields.userSettingTheme] as String,
      userSettingMonetaryFormat:
          row[UserSettingFields.userSettingMonetaryFormat] as String,
      userSettingUserId: row[UserSettingFields.userSettingUserId] as String,
    );
  }

  /// Table name of the user setting
  static const String tableName = 'user_settings';

  /// The id of the user setting
  final String id;

  /// The id of the user setting
  final String userSettingId;

  /// The base currency code of the user setting
  final String? userSettingBaseCurrencyCode;

  /// The language code of the user setting
  @JsonKey(defaultValue: 'system')
  final String userSettingLanguageCode;

  /// The date format of the user setting
  @JsonKey(defaultValue: 'system')
  final String userSettingDateFormat;

  /// The default wallet of the user setting
  final String? userSettingDefaultWallet;

  /// The created at of the user setting
  final DateTime userSettingCreatedAt;

  /// The updated at of the user setting
  final DateTime userSettingUpdatedAt;

  /// The theme of the user setting
  @JsonKey(defaultValue: 'system')
  final String userSettingTheme;

  /// The monetary format of the user setting
  @JsonKey(defaultValue: 'system')
  final String userSettingMonetaryFormat;

  /// The user id of the user setting
  final String? userSettingUserId;

  /// Creates a copy of this [UserSetting] but with the given fields
  UserSetting copyWith({
    String? userSettingId,
    String? userSettingBaseCurrencyCode,
    String? userSettingLanguageCode,
    String? userSettingDateFormat,
    String? userSettingDefaultWallet,
    String? userSettingTheme,
    String? userSettingMonetaryFormat,
    String? userSettingUserId,
    DateTime? userSettingCreatedAt,
    DateTime? userSettingUpdatedAt,
  }) {
    return UserSetting(
      userSettingId: userSettingId ?? this.userSettingId,
      userSettingBaseCurrencyCode:
          userSettingBaseCurrencyCode ?? this.userSettingBaseCurrencyCode,
      userSettingLanguageCode:
          userSettingLanguageCode ?? this.userSettingLanguageCode,
      userSettingDateFormat:
          userSettingDateFormat ?? this.userSettingDateFormat,
      userSettingDefaultWallet:
          userSettingDefaultWallet ?? this.userSettingDefaultWallet,
      userSettingTheme: userSettingTheme ?? this.userSettingTheme,
      userSettingMonetaryFormat:
          userSettingMonetaryFormat ?? this.userSettingMonetaryFormat,
      userSettingUserId: userSettingUserId ?? this.userSettingUserId,
      userSettingCreatedAt: userSettingCreatedAt ?? this.userSettingCreatedAt,
      userSettingUpdatedAt: userSettingUpdatedAt ?? this.userSettingUpdatedAt,
    );
  }
}
