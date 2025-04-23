import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthenticationClient extends Fake implements AuthenticationClient {}

void main() {
  test('AuthenticationClient can be implemented', () {
    expect(FakeAuthenticationClient.new, returnsNormally);
  });

  test('exports SignUpWithEmailAndPasswordFailure', () {
    expect(
      () => const SignUpWithEmailAndPasswordFailure('error'),
      returnsNormally,
    );
  });

  test('exports LoginWithEmailPasswordLoginFailure', () {
    expect(
      () => const LogInWithEmailPasswordFailure('error'),
      returnsNormally,
    );
  });

  test('exports LoginWithGoogleFailure', () {
    expect(
      () => const LogInWithGoogleFailure('error'),
      returnsNormally,
    );
  });

  test('exports LoginWithGoogleCancelled', () {
    expect(
      () => const LogInWithGoogleCanceled('error'),
      returnsNormally,
    );
  });

  test('exports LoginWithAppleFailure', () {
    expect(
      () => const LogInWithAppleFailure('error'),
      returnsNormally,
    );
  });

  test('exports LoginWithAppleCancelled', () {
    expect(
      () => const LogInWithAppleCancelled('error'),
      returnsNormally,
    );
  });
}
