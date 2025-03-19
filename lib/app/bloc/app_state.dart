part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated;

  bool get isAuthenticated => this == AppStatus.authenticated;
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.unauthenticated,
    this.user = User.anonymous,
  });

  const AppState.authenticated(User user)
      : this(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated()
      : this(status: AppStatus.unauthenticated, user: User.anonymous);

  final AppStatus status;
  final User user;

  AppState copyWith({
    AppStatus? status,
    User? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
