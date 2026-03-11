part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const SimplePassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
  });

  final Email email;
  final SimplePassword password;
  final bool valid;
  final FormzSubmissionStatus status;

  LoginState copyWith({
    Email? email,
    SimplePassword? password,
    FormzSubmissionStatus? status,
    bool? valid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }

  @override
  List<Object> get props => [email, password, status, valid];
}
