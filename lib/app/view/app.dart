import 'package:ai_client/ai_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/l10n/arb/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text_client/speech_to_text_client.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required User user,
    required WalletRepository walletRepository,
    required AiClient aiClient,
    super.key,
  })  : _userRepository = userRepository,
        _walletRepository = walletRepository,
        _user = user,
        _aiClient = aiClient;
  final UserRepository _userRepository;
  final WalletRepository _walletRepository;
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
        RepositoryProvider<AiClient>.value(
          value: _aiClient,
        ),
        RepositoryProvider<SpeechToTextClient>(
          create: (context) => SpeechToTextClient(),
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
    return KeyboardHeightProvider(
      child: MaterialApp.router(
        theme: theme.light(),
        darkTheme: theme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
