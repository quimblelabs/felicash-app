part of 'user_setting_bloc.dart';

sealed class UserSettingEvent extends Equatable {
  const UserSettingEvent();

  @override
  List<Object> get props => [];
}

class UserSettingSubscriptionRequested extends UserSettingEvent {
  const UserSettingSubscriptionRequested();
}
