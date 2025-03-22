import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/modal_bottom_sheet_page.dart';
import 'package:felicash/home/view/home_page.dart';
import 'package:felicash/login/view/login_page.dart';
import 'package:felicash/onboarding/view/onboarding_page.dart';
import 'package:felicash/overview/view/overview_page.dart';
import 'package:felicash/personal/view/personal_page.dart';
import 'package:felicash/transaction/view/transactions_page.dart';
import 'package:felicash/wallet/view/create_wallet_modal.dart';
import 'package:felicash/wallet/view/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The paths of the routes.
abstract class AppRoutes {
  static const onboarding = '/';
  static const login = '/login';
  static const overview = '/overview';
  static const transactions = '/transactions';
  static const wallets = '/wallets';
  static const personal = '/personal';
}

/// The names of the routes.
abstract class AppRouteNames {
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const overview = 'overview';
  static const transactions = 'transactions';
  static const wallets = 'wallets';
  static const personal = 'personal';
}

class AppRouter {
  AppRouter(AppBloc appBloc) {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.onboarding,
      refreshListenable: StreamToListenable(
        [appBloc.stream.map((state) => state.status)],
      ),
      redirect: _redirect,
      routes: [
        GoRoute(
          name: AppRouteNames.onboarding,
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          name: AppRouteNames.login,
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        StatefulShellRoute.indexedStack(
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
          path: '/create-wallet',
          pageBuilder: (context, state) {
            return ModelBottomSheetPage(
              builder: (context) => const CreateWalletModal(),
            );
          },
        ),
      ],
    );
  }
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _homeShellNavigationKey = GlobalKey<NavigatorState>();

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
