import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/modal_page.dart';
import 'package:felicash/home/view/home_page.dart';
import 'package:felicash/login/view/login_page.dart';
import 'package:felicash/onboarding/view/onboarding_page.dart';
import 'package:felicash/overview/view/overview_page.dart';
import 'package:felicash/personal/view/personal_page.dart';
import 'package:felicash/transaction/view/add_transaction_modal.dart';
import 'package:felicash/transaction/view/transactions_page.dart';
import 'package:felicash/wallet/view/wallets_page.dart';
import 'package:felicash/wallet_creation/view/monetary_input_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_creation_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_type_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// The paths of the routes.
abstract class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const overview = '/';
  static const transactions = '/transactions';
  static const personal = '/personal';

  static const wallets = '/wallets';
  // Creatation flow
  static const String walletTypeSelector = '/select-type';
  static const String createWallet = '/create/:type';
  static const String balanceUpdation = '/update-balance';

  // Create transaction
  static const String creteTransaction = '/create-transaction';
}

abstract class AppRouteNames {
  static const login = 'login';
  static const onboarding = 'onboarding';
  static const overview = 'overview';
  static const transactions = 'transactions';
  static const personal = 'personal';
  static const wallets = 'wallets';

  // Creatation flow
  static const walletTypeSelector = 'selectWalletType';
  static const walletCreation = 'createWallet';
  static const balanceUpdation = 'updateBalance';

  // Create transaction
  static const creteTransaction = 'createTransaction';
}

class AppRouter {
  AppRouter(AppBloc appBloc) {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.onboarding,
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
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state, navigationShell) {
            return HomePage(child: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.overview,
                  path: AppRoutes.overview,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: OverviewPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.transactions,
                  path: AppRoutes.transactions,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: TransactionsPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteNames.wallets,
                  path: AppRoutes.wallets,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: WalletPage()),
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
                      path: AppRoutes.createWallet,
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
                          name: AppRouteNames.balanceUpdation,
                          path: AppRoutes.balanceUpdation,
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
                                initalValue: double.parse(initial!),
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
                      const NoTransitionPage(child: PersonalPage()),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.creteTransaction,
          name: AppRouteNames.creteTransaction,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            return ModalPage(
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => const AddTransactionModal(),
            );
          },
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

    final overviewLoc = state.namedLocation(AppRouteNames.overview);

    if (!isAuthenticated && !onboardingIn && !loggingIn) {
      return onboardingLoc;
    }
    if (isAuthenticated && onboardingIn) {
      return overviewLoc;
    }

    return null;
  }
}
