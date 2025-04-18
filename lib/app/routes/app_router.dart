import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:felicash/ai_assistant/view/ai_assistant_page.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/pages/fade_transition_page.dart';
import 'package:felicash/app/routes/pages/modal_page.dart';
import 'package:felicash/home/view/home_page.dart';
import 'package:felicash/login/view/login_page.dart';
import 'package:felicash/onboarding/view/onboarding_page.dart';
import 'package:felicash/overview/overview/view/overview_page.dart';
import 'package:felicash/personal/view/personal_page.dart';
import 'package:felicash/transaction/view/transaction_creation_modal.dart';
import 'package:felicash/transaction/view/transactions_page.dart';
import 'package:felicash/voice_transaction/view/voice_transaction_page.dart';
import 'package:felicash/wallet/view/wallets_page.dart';
import 'package:felicash/wallet_creation/view/monetary_input_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_creation_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_type_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';

/// The paths of the routes.
abstract class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const overview = '/';
  static const transactions = '/transactions';
  static const personal = '/personal';

  static const wallets = '/wallets';
  // Add new AI Assistant route
  static const String aiAssistant = '/ai-assistant';
  // Creation flow
  static const String walletTypeSelector = '/select-type';
  static const String walletCreation = '/create/:type';
  static const String balanceUpdate = '/update-balance';

  // Create transaction
  static const String transactionCreation = '/create-transaction';

  // Voice transaction
  static const String voiceTransaction = '/voice-transaction';
}

abstract class AppRouteNames {
  static const login = 'login';
  static const onboarding = 'onboarding';
  static const overview = 'overview';
  static const transactions = 'transactions';
  static const personal = 'personal';
  static const wallets = 'wallets';

  // Add new AI Assistant route name
  static const aiAssistant = 'aiAssistant';

  // Creation flow
  static const walletTypeSelector = 'selectWalletType';
  static const walletCreation = 'createWallet';
  static const balanceUpdate = 'updateBalance';

  // Create transaction
  static const transactionCreation = 'createTransaction';

  // Voice transaction
  static const voiceTransaction = 'voiceTransaction';
}

class AppRouter {
  AppRouter(AppBloc appBloc) {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.overview,
      debugLogDiagnostics: true,
      refreshListenable: StreamToListenable(
        [appBloc.stream.map((state) => state.status)],
      ),
      redirect: _redirect,
      routes: [
        GoRoute(
          name: AppRouteNames.onboarding,
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          name: AppRouteNames.login,
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        StatefulShellRoute(
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state, navigationShell) {
            return navigationShell;
          },
          navigatorContainerBuilder: (context, navigationShell, children) {
            return HomePage(
              navigationShell: navigationShell,
              children: children,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.overview,
                  path: AppRoutes.overview,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const OverviewPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                  routes: [
                    GoRoute(
                      path: AppRoutes.transactionCreation,
                      name: AppRouteNames.transactionCreation,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        const walletId = '9ca6c9b6-e206-4222-b22e-cf0741ff4779';
                        // state.uri.queryParameters['walledId'];
                        return ModalPage(
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => const TransactionCreationModal(
                            walletId: walletId,
                          ),
                        );
                      },
                    ),
                    GoRoute(
                      path: AppRoutes.voiceTransaction,
                      name: AppRouteNames.voiceTransaction,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        return CustomTransitionPage(
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: const VoiceTransactionPage(),
                        );
                      },
                    ),
                    GoRoute(
                      path: AppRoutes.aiAssistant,
                      name: AppRouteNames.aiAssistant,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        return const AiAssistantPage();
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.transactions,
                  path: AppRoutes.transactions,
                  pageBuilder: (context, state) => FadeTransitionPage(
                    key: state.pageKey,
                    child: const TransactionsPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.wallets,
                  path: AppRoutes.wallets,
                  pageBuilder: (context, state) => FadeTransitionPage(
                    key: state.pageKey,
                    child: const WalletPage(),
                  ),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRouteNames.walletTypeSelector,
                      path: AppRoutes.walletTypeSelector,
                      pageBuilder: (context, state) {
                        return ModalPage(
                          isScrollControlled: false,
                          builder: (context) => const WalletTypeSelectorModal(),
                        );
                      },
                    ),
                    GoRoute(
                      name: AppRouteNames.walletCreation,
                      path: AppRoutes.walletCreation,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        final type = state.pathParameters['type'];
                        final enumType = WalletTypeEnum.values.firstWhere(
                          (e) => e.name == type,
                        );
                        return ModalPage(
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => WalletCreationModal(
                            walletType: enumType,
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: AppRouteNames.balanceUpdate,
                          path: AppRoutes.balanceUpdate,
                          parentNavigatorKey: _rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final initial =
                                state.uri.queryParameters['initial'];
                            final currency =
                                state.uri.queryParameters['currency'];
                            return ModalPage(
                              isScrollControlled: false,
                              useSafeArea: true,
                              builder: (context) => MonetaryInputModal(
                                initialValue: double.parse(initial!),
                                currencySymbol: currency!,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.personal,
                  path: AppRoutes.personal,
                  pageBuilder: (context, state) =>
                      const FadeTransitionPage(child: PersonalPage()),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router;
  GoRouter get router => _router;

  FutureOr<String?> _redirect(BuildContext context, GoRouterState state) {
    final isAuthenticated =
        context.read<AppBloc>().state.status.isAuthenticated;
    final currentLoc = state.uri.toString();

    final onboardingLoc = state.namedLocation(AppRouteNames.onboarding);
    final onboardingIn = onboardingLoc == currentLoc;

    final loginLoc = state.namedLocation(AppRouteNames.login);
    final loggingIn = loginLoc == currentLoc;

    if (!isAuthenticated && (!onboardingIn || !loggingIn)) {
      return loginLoc;
    }

    return null;
  }
}
