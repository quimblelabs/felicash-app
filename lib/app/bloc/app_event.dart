part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Emits when the app is opened.
class AppOpened extends AppEvent {}

class AppLogOutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  /// Current user. If not authenticated, [User.anonymous] is emitted.
  final User user;

  @override
  List<Object?> get props => [user];
}

class AppDeleteAccountRequested extends AppEvent {}
