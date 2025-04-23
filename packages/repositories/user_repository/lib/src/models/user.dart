import 'package:authentication_client/authentication_client.dart';

/// {@template user}
/// Application user.
/// {@endtemplate}
class User extends AuthenticationUser {
  /// {@macro user}
  const User({
    required super.id,
    super.email,
    super.phone,
    super.displayName,
    super.isNewUser = false,
  });

  /// Creates a user from an [AuthenticationUser].
  factory User.fromAuthenticationUser(AuthenticationUser user) => User(
        id: user.id,
        email: user.email,
        phone: user.phone,
        displayName: user.displayName,
        isNewUser: user.isNewUser,
      );

  @override
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = User(id: '');
}
