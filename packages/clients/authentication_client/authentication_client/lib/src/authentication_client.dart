import 'package:authentication_client/src/models/authentication_user.dart';

/// {@template authentication_exception}
/// Exceptions from the authentication client.
/// {@endtemplate}
abstract class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown durring the sign up with email and password process
/// if an error occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure extends AuthenticationException {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure(super.error);
}

/// {@template login_with_email_password_failure}
/// Thrown durring the email and password login process if an error occurs.
/// {@endtemplate}
class LogInWithEmailPasswordFailure extends AuthenticationException {
  /// {@macro login_with_email_password_failure}
  const LogInWithEmailPasswordFailure(super.error);
}

/// {@template login_with_google_failure}
/// Thrown durring the login with Google process if an error occurs.
/// {@endtemplate}
class LogInWithGoogleFailure extends AuthenticationException {
  /// {@macro login_with_google_failure}
  const LogInWithGoogleFailure(super.error);
}

/// {@template login_with_google_canceled}
/// Thrown durring the login with Google process if the user cancels.
/// {@endtemplate}
class LogInWithGoogleCanceled extends AuthenticationException {
  /// {@macro login_with_google_canceled}
  const LogInWithGoogleCanceled(super.error);
}

/// {@template login_with_apple_failure}
/// Thrown durring the login with Apple process if an error occurs.
/// {@endtemplate}
class LogInWithAppleFailure extends AuthenticationException {
  /// {@macro login_with_apple_failure}
  const LogInWithAppleFailure(super.error);
}

/// {@template login_with_apple_cancelled}
/// Thrown durring the login with Apple process if the user cancels.
/// {@endtemplate}
class LogInWithAppleCancelled extends AuthenticationException {
  /// {@macro login_with_apple_cancelled}
  const LogInWithAppleCancelled(super.error);
}

/// {@template log_out_failure}
/// Thrown during the logout process if a failure occurs.
/// {@endtemplate}
class LogOutFailure extends AuthenticationException {
  /// {@macro log_out_failure}
  const LogOutFailure(super.error);
}

/// {@template delete_account_failure}
/// Thrown during the delete account process if a failure occurs.
/// {@endtemplate}
class DeleteAccountFailure extends AuthenticationException {
  /// {@macro delete_account_failure}
  const DeleteAccountFailure(super.error);
}

/// {@template authentication_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract interface class AuthenticationClient {
  /// {@macro authentication_client}
  const AuthenticationClient();

  /// Stream of [AuthenticationUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthenticationUser.anonymous] if the user is not authenticated.
  Stream<AuthenticationUser> get user;

  /// Start the sign in with Google flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an error occurs.
  Future<void> loginWithGoogle();

  /// Start the sign in with Apple flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an error occurs.
  Future<void> loginWithApple();

  /// Start the sign up with email and password flow.
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an error occurs.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Start the sign in with email and password flow.
  ///
  /// Throws a [LogInWithEmailPasswordFailure] if an error occurs.
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user which will emit
  /// [AuthenticationUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut();

  /// Deletes the current user account.
  ///
  /// Throws a [DeleteAccountFailure] if an exception occurs.
  Future<void> deleteAccount();
}
