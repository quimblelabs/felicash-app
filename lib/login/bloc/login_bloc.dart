import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginWithEmailPasswordSubmitted>(
      _onLoginWithEmailPasswordSubmitted,
    );
    on<LoginWithGoogleSubmitted>(_onLoginWithGoogleSubmitted);
  }

  late final UserRepository _userRepository;

  void _onLoginEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        valid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = SimplePassword.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        valid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onLoginWithEmailPasswordSubmitted(
    LoginWithEmailPasswordSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.valid) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        await _userRepository.loginWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e, stackTrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        addError(e, stackTrace);
      }
    }
  }

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
