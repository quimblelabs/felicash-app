import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginWithGoogleSubmitted>(_onLoginWithGoogleSubmitted);
  }

  late final UserRepository _userRepository;

  Future<void> _onLoginWithGoogleSubmitted(
    LoginWithGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      await _userRepository.loginWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(e, stackTrace);
    }
  }
}
