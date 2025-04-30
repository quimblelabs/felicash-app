import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

/// {@template user_settings_model}
/// User settings model.
/// Store all user settings.
/// {@endtemplate}
@freezed
abstract class UserSettingsModel with _$UserSettingsModel {
  /// {@macro user_settings_model}
  const factory UserSettingsModel({
    String? id,
    @Default('system') String theme,
    @Default('system') String language,
    String? defaultWalletId,
    String? currency,
    @Default('system') String txDateFormat,
    @Default('system') String monetaryFormat,
  }) = _UserSettingsModel;

  /// Factory constructor for [UserSettingsModel] from JSON
  ///
  /// {@macro user_settings_model}
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  /// Factory constructor for [UserSettingsModel] from [UserSetting]
  ///
  /// {@macro user_settings_model}
  factory UserSettingsModel.fromUserSetting(UserSetting userSetting) =>
      UserSettingsModel(
        id: userSetting.id,
        theme: userSetting.userSettingTheme,
        language: userSetting.userSettingTheme,
        defaultWalletId: userSetting.userSettingDefaultWallet,
        currency: userSetting.userSettingBaseCurrencyCode,
        txDateFormat: userSetting.userSettingDateFormat,
        monetaryFormat: userSetting.userSettingMonetaryFormat,
      );

  /// Create a new user settings model.
  ///
  /// {@macro user_settings_model}
  factory UserSettingsModel.create({
    String? id,
    String? theme,
    String? language,
    String? defaultWalletId,
    String? currency,
    String? txDateFormat,
    String? monetaryFormat,
  }) {
    return UserSettingsModel(
      id: id ?? const Uuid().v4(),
      theme: theme ?? 'system',
      language: language ?? 'system',
      defaultWalletId: defaultWalletId,
      currency: currency,
      txDateFormat: txDateFormat ?? 'system',
      monetaryFormat: monetaryFormat ?? 'system',
    );
  }
}
