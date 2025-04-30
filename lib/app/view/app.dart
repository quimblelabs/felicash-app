import 'package:ai_client/ai_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/category/bloc/categories_bloc.dart';
import 'package:felicash/currency/bloc/currencies_bloc.dart';
import 'package:felicash/l10n/arb/app_localizations.dart';
import 'package:felicash/user_setting/bloc/user_setting_bloc.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text_client/speech_to_text_client.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:text_to_speech_client/text_to_speech_client.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:user_setting_repository/user_setting_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatelessWidget {
  const App({
    required User user,
    required UserRepository userRepository,
    required WalletRepository walletRepository,
    required CategoryRepository categoryRepository,
    required CurrencyRepository currencyRepository,
    required TransactionRepository transactionRepository,
    required UserSettingRepository userSettingRepository,
    required ElevenLabsTextToSpeechClient elevenLabsTextToSpeechClient,
    required OpenAITextToSpeechClient openAITextToSpeechClient,
    required AiClient aiClient,
    super.key,
  })  : _userRepository = userRepository,
        _walletRepository = walletRepository,
        _categoryRepository = categoryRepository,
        _currencyRepository = currencyRepository,
        _transactionRepository = transactionRepository,
        _userSettingRepository = userSettingRepository,
        _elevenLabsTextToSpeechClient = elevenLabsTextToSpeechClient,
        _openAITextToSpeechClient = openAITextToSpeechClient,
        _user = user,
        _aiClient = aiClient;
  final UserRepository _userRepository;
  final WalletRepository _walletRepository;
  final CategoryRepository _categoryRepository;
  final CurrencyRepository _currencyRepository;
  final TransactionRepository _transactionRepository;
  final UserSettingRepository _userSettingRepository;
  final ElevenLabsTextToSpeechClient _elevenLabsTextToSpeechClient;
  final OpenAITextToSpeechClient _openAITextToSpeechClient;
  final User _user;
  final AiClient _aiClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: _userRepository,
        ),
        RepositoryProvider<WalletRepository>.value(
          value: _walletRepository,
        ),
        RepositoryProvider<CategoryRepository>.value(
          value: _categoryRepository,
        ),
        RepositoryProvider<CurrencyRepository>.value(
          value: _currencyRepository,
        ),
        RepositoryProvider<TransactionRepository>.value(
          value: _transactionRepository,
        ),
        RepositoryProvider<AiClient>.value(
          value: _aiClient,
        ),
        RepositoryProvider<SpeechToTextClient>.value(
          value: SpeechToTextClient(),
        ),
        RepositoryProvider<UserSettingRepository>.value(
          value: _userSettingRepository,
        ),
        RepositoryProvider<ElevenLabsTextToSpeechClient>.value(
          value: _elevenLabsTextToSpeechClient,
        ),
        RepositoryProvider<OpenAITextToSpeechClient>.value(
          value: _openAITextToSpeechClient,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              userRepository: _userRepository,
              user: _user,
            ),
          ),
          BlocProvider<WalletsBloc>(
            create: (context) => WalletsBloc(
              walletRepository: _walletRepository,
            )..add(
                const WalletsSubscriptionRequested(
                  query: GetWalletQuery(
                    archived: false,
                  ),
                ),
              ),
          ),
          BlocProvider<CategoriesBloc>(
            create: (context) => CategoriesBloc(
              categoryRepository: _categoryRepository,
            )..add(
                const CategoriesSubscriptionRequested(
                  query: GetCategoryQuery(
                    enabled: true,
                  ),
                ),
              ),
          ),
          BlocProvider<CurrenciesBloc>(
            create: (context) => CurrenciesBloc(
              currencyRepository: _currencyRepository,
            )..add(
                const CurrenciesFetched(),
              ),
          ),
          BlocProvider<UserSettingBloc>(
            create: (context) => UserSettingBloc(
              userSettingRepository: _userSettingRepository,
            )..add(
                const UserSettingSubscriptionRequested(),
              ),
          ),
        ],
        child: RepositoryProvider<AppRouter>(
          create: (context) => AppRouter(context.read()),
          child: const AppView(),
        ),
      ),
    );
  }
}

@visibleForTesting
class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final interTextTheme = GoogleFonts.interTextTheme();
    final theme = AppTheme(interTextTheme);
    final router = context.read<AppRouter>().router;
    return _OnAuthenticatedUser(
      child: KeyboardHeightProvider(
        child: MaterialApp.router(
          theme: theme.light(),
          darkTheme: theme.dark(),
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        ),
      ),
    );
  }
}

class _OnAuthenticatedUser extends StatelessWidget {
  const _OnAuthenticatedUser({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.user != current.user,
      listener: (context, state) {
        if (!state.user.isAnonymous) {}
      },
      child: child,
    );
  }
}
