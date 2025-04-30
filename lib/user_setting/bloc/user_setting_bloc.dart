import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:user_setting_repository/user_setting_repository.dart';

part 'user_setting_event.dart';
part 'user_setting_state.dart';

class UserSettingBloc extends Bloc<UserSettingEvent, UserSettingState> {
  UserSettingBloc({
    required UserSettingRepository userSettingRepository,
  })  : _userSettingRepository = userSettingRepository,
        super(const UserSettingInitial()) {
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
    emit(const UserSettingLoadInProgress());

    await emit.forEach(
      _userSettingRepository.getUserSettingStream(),
      onData: (userSetting) => UserSettingLoadSuccess(
        userSetting: userSetting,
      ),
      onError: (error, stack) => UserSettingLoadFailure(error: error),
    );
  }
}
