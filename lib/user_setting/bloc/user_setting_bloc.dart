import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/user_setting/models/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_setting_repository/user_setting_repository.dart';

part 'user_setting_event.dart';
part 'user_setting_state.dart';
part 'user_setting_bloc.freezed.dart';

class UserSettingBloc extends Bloc<UserSettingEvent, UserSettingState> {
  UserSettingBloc({
    required UserSettingRepository userSettingRepository,
  })  : _userSettingRepository = userSettingRepository,
        super(UserSettingState.initial()) {
    on<UserSettingSubscriptionRequested>(
      _onUserSettingSubscriptionRequested,
      transformer: restartable(),
    );
  }

  final UserSettingRepository _userSettingRepository;

  Future<void> _onUserSettingSubscriptionRequested(
    UserSettingSubscriptionRequested event,
    Emitter<UserSettingState> emit,
  ) async {
    final setting = await _userSettingRepository.getUserSettingFuture();
    if (setting == null) {
      final defaultSetting = UserSettingsModel.create();
      await _userSettingRepository.createUserSetting(defaultSetting);
    }
    await emit.forEach(
      _userSettingRepository.getUserSettingStream(),
      onData: (userSetting) {
        return UserSettingState(
          themeMode: _fromSettings(userSetting),
        );
      },
      onError: (error, stack) {
        log(error.toString(), error: error, stackTrace: stack);
        return state;
      },
    );
  }

  ThemeMode _fromSettings(UserSettingsModel? appSettings) {
    if (appSettings == null) {
      return ThemeMode.system;
    }
    switch (appSettings.theme) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
