import 'package:felicash/app/app.dart';
import 'package:felicash/main/bootstrap.dart';
import 'package:felicash/main/firebase_options_dev.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

void main() {
  bootstrap((dataClient) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final tokenStorage = InMemoryTokenStorage();
    final authenticationClient = SupabaseAuthenticationClient(
      tokenStorage: tokenStorage,
      goTrueAuthClient: Supabase.instance.client.auth,
    );
    final userRepository = UserRepository(
      authenticationClient: authenticationClient,
    );
    final walletRepository = WalletRepository(
      client: dataClient,
    );
    return App(
      userRepository: userRepository,
      user: await userRepository.user.first,
      walletRepository: walletRepository,
    );
  });
}
