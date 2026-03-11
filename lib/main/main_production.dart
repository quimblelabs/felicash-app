import 'package:category_repository/category_repository.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:dio/dio.dart';
import 'package:dio_client/dio_client.dart';
import 'package:felicash/app/app.dart';
import 'package:felicash/main/bootstrap.dart';
import 'package:felicash/main/firebase_options_prod.dart';
import 'package:felicash_storage_client/felicash_storage_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:n8n_ai_client/n8n_ai_client.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:text_to_speech_client/text_to_speech_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:user_setting_repository/user_setting_repository.dart';
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

    final felicashStorageClient = FelicashStorageClient(
      supabaseClient: Supabase.instance.client,
    );

    final userRepository = UserRepository(
      authenticationClient: authenticationClient,
    );
    final walletRepository = WalletRepository(
      client: dataClient,
    );

    final categoryRepository = CategoryRepository(
      client: dataClient,
    );

    const currencyRepository = CurrencyRepository();

    final transactionRepository = TransactionRepository(
      client: dataClient,
    );

    final userSettingRepository = UserSettingRepository(
      client: dataClient,
    );

    final dio = Dio();
    dio.interceptors.add(
      BearerTokenInterceptor(
        tokenProvider: tokenStorage.getToken,
        refreshTokenProvider: () async {
          await Supabase.instance.client.auth.refreshSession();
          return tokenStorage.getToken();
        },
      ),
    );

    final aiClient = N8nAiClient(
      dio,
      baseUrl: const String.fromEnvironment('N8N_BASE_URL'),
    );

    final elevenLabsTextToSpeechClient = ElevenLabsTextToSpeechClient(
      apiKey: const String.fromEnvironment('ELEVENLABS_API_KEY'),
      baseUrl: const String.fromEnvironment('ELEVENLABS_BASE_URL'),
    );

    final openAITextToSpeechClient = OpenAITextToSpeechClient(
      apiKey: const String.fromEnvironment('OPENAI_API_KEY'),
      baseUrl: const String.fromEnvironment('OPENAI_BASE_URL'),
    );

    return App(
      user: await userRepository.user.first,
      aiClient: aiClient,
      elevenLabsTextToSpeechClient: elevenLabsTextToSpeechClient,
      openAITextToSpeechClient: openAITextToSpeechClient,
      felicashStorageClient: felicashStorageClient,
      userRepository: userRepository,
      walletRepository: walletRepository,
      categoryRepository: categoryRepository,
      currencyRepository: currencyRepository,
      transactionRepository: transactionRepository,
      userSettingRepository: userSettingRepository,
    );
  });
}
