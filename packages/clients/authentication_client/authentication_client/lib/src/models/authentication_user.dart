import 'package:equatable/equatable.dart';

///{@template authentication_user}
///
/// Authentication User
///
/// [AuthenticationUser.anonymous] represent an unauthenticated user.
/// {@endtemplate}
class AuthenticationUser extends Equatable {
  /// {@macro authentication_user}
  const AuthenticationUser({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
    this.isNewUser = false,
  });

  /// The current user's unique ID.
  final String id;

  /// The current user's email address.
  final String? email;

  //// The current user's phone number.
  final String? phone;

  /// The current user's display name.
  final String? displayName;

  /// Whether the current user is a first time user.
  final bool isNewUser;

  /// Whether the current user is anonymous.
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = AuthenticationUser(id: '');

  @override
  List<Object?> get props => [id, email, displayName, isNewUser, phone];
}
