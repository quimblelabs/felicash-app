part of 'user_setting_bloc.dart';

sealed class UserSettingState extends Equatable {
  const UserSettingState();

  @override
  List<Object?> get props => [];
}

final class UserSettingInitial extends UserSettingState {
  const UserSettingInitial();

  @override
  List<Object> get props => [];
}

final class UserSettingLoadInProgress extends UserSettingState {
  const UserSettingLoadInProgress({
    this.userSettings,
    this.messageText = 'Loading user settings...',
  });
  final UserSettingsModel? userSettings;
  final String messageText;

  @override
  List<Object?> get props => [messageText, userSettings];
}

final class UserSettingLoadSuccess extends UserSettingState {
  const UserSettingLoadSuccess({
    this.userSetting,
  });
  final UserSettingsModel? userSetting;

  @override
  List<Object?> get props => [userSetting];
}

final class UserSettingLoadFailure extends UserSettingState {
  const UserSettingLoadFailure({
    required this.error,
    this.messageText = 'Error when load user settings',
  });
  final String messageText;

  final Object error;

  @override
  List<Object?> get props => [messageText, error];
}
