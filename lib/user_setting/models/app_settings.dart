import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_setting_repository/user_setting_repository.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _AppSettings;

  factory AppSettings.inital() => const AppSettings();
}

extension AppSettingsX on AppSettings {
  /// Convert to [UserSettingsModel]
  UserSettingsModel toUserSettingsModel() {
    return UserSettingsModel(
      theme: themeMode.name,
    );
  }
}
