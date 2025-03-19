import 'package:authentication_client/authentication_client.dart';
import 'package:user_repository/src/models/user.dart';

/// {@template user_repository}
/// User repository.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AuthenticationClient authenticationClient,
  }) : _authenticationClient = authenticationClient;

  final AuthenticationClient _authenticationClient;

  /// Stream of current logged user.
  Stream<User> get user {
    return _authenticationClient.user.map(User.fromAuthenticationUser);
  }

  /// Start the sign in with Google flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an error occurs.
  Future<void> loginWithGoogle() async {
    try {
      await _authenticationClient.loginWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(e), stacktrace);
    }
  }

  /// Start the sign in with Apple flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an error occurs.
  Future<void> loginWithApple() async {
    try {
      await _authenticationClient.loginWithApple();
    } on LogInWithAppleFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(LogInWithAppleFailure(e), stacktrace);
    }
  }

  /// Start the sign up with email and password flow.
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an error occurs.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on SignUpWithEmailAndPasswordFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(
        SignUpWithEmailAndPasswordFailure(e),
        stacktrace,
      );
    }
  }

  /// Start the sign in with email and password flow.
  ///
  /// Throws a [LogInWithEmailPasswordFailure] if an error occurs.
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on LogInWithEmailPasswordFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(
        LogInWithEmailPasswordFailure(e),
        stacktrace,
      );
    }
  }

  /// Signs out the current user which will emit
  /// [AuthenticationUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(LogOutFailure(e), stacktrace);
    }
  }

  /// Deletes the current user account.
  ///
  /// Throws a [DeleteAccountFailure] if an exception occurs.
  Future<void> deleteAccount() async {
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(e), stacktrace);
    }
  }
}
