part of 'user_setting_bloc.dart';

@freezed
abstract class UserSettingState with _$UserSettingState {
  factory UserSettingState({
    required ThemeMode themeMode,
  }) = _UserSettingState;

  factory UserSettingState.initial() {
    return UserSettingState(
      themeMode: ThemeMode.system,
    );
  }
}
