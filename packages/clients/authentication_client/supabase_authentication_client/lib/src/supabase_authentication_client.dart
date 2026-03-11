import 'dart:convert';
import 'dart:io';

import 'package:authentication_client/authentication_client.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';

/// Signature for [SignInWithApple.getAppleIDCredential]
typedef GetAppleCredentials = Future<AuthorizationCredentialAppleID> Function({
  required List<AppleIDAuthorizationScopes> scopes,
  WebAuthenticationOptions webAuthenticationOptions,
  String nonce,
  String state,
});

/// {@template supabase_authentication_client}
/// A Supabase implementation of [AuthenticationClient].
/// {@endtemplate}
class SupabaseAuthenticationClient implements AuthenticationClient {
  /// {@macro supabase_authentication_client}
  SupabaseAuthenticationClient({
    required TokenStorage tokenStorage,
    required GoTrueClient goTrueAuthClient,
    GoogleSignIn? googleSignIn,
    GetAppleCredentials? getAppleCredentials,
  })  : _tokenStorage = tokenStorage,
        _auth = goTrueAuthClient,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential {
    _auth.onAuthStateChange.listen(_onSessionChanged);
  }

  final TokenStorage _tokenStorage;
  final GoTrueClient _auth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;

  @override
  Stream<AuthenticationUser> get user {
    return _auth.onAuthStateChange.map((state) {
      if (state.session?.user case final currentUser?) {
        return AuthenticationUser(
          id: currentUser.id,
          email: currentUser.email,
          phone: currentUser.phone,
          isNewUser: currentUser.createdAt == currentUser.lastSignInAt,
        );
      } else {
        return AuthenticationUser.anonymous;
      }
    });
  }

  @override
  Future<void> loginWithApple() async {
    try {
      final rawNonce = _auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await _getAppleCredentials(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const LogInWithAppleFailure(
          'Could not find ID Token from generated credential.',
        );
      }

      if (Platform.isIOS || Platform.isMacOS) {
        await _auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } else {
        final redirectUrl = Uri.https(
          const String.fromEnvironment('FLAVOR_DEEP_LINK_DOMAIN'),
          // ignore: avoid_redundant_argument_values
          const String.fromEnvironment('FLAVOR_DEEP_LINK_PATH'),
        );
        // TODO(tuanhm): Test and fix this on android
        await _auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: kIsWeb
              ? null //
              : redirectUrl.toString(),
          authScreenLaunchMode: kIsWeb
              ? LaunchMode.platformDefault
              : LaunchMode.externalApplication,
        );
      }
    } on LogInWithAppleCancelled {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(LogInWithAppleFailure(e), stackTrace);
    }
  }

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LogInWithEmailPasswordFailure(e),
        stackTrace,
      );
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleCanceled(
          Exception('Sign in with Google canceled'),
        );
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null) {
        throw LogInWithGoogleFailure(
          Exception('Google sign in failed, missing id token'),
        );
      }
      if (accessToken == null) {
        throw LogInWithGoogleFailure(
          Exception('Google sign in failed, missing access token'),
        );
      }
      await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      //TODO: Test and handle when email already exists
      await _auth.signUp(
        email: email,
        password: password,
      );
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        SignUpWithEmailAndPasswordFailure(e),
        stackTrace,
      );
    }
  }

  Future<void> _onSessionChanged(AuthState authStatte) async {
    final session = authStatte.session;
    if (session == null) {
      await _tokenStorage.clearToken();
    } else {
      await _tokenStorage.saveToken(session.accessToken);
    }
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    try {
      return _auth.signOut();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(e), stackTrace);
    }
  }
}
