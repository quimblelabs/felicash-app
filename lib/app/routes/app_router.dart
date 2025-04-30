import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/view/ai_assistant_page.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/routes/app_router_extra_codec.dart';
import 'package:felicash/app/routes/pages/fade_transition_page.dart';
import 'package:felicash/app/routes/pages/modal_page.dart';
import 'package:felicash/home/view/home_page.dart';
import 'package:felicash/login/view/login_page.dart';
import 'package:felicash/onboarding/view/onboarding_page.dart';
import 'package:felicash/overview/overview/view/overview_page.dart';
import 'package:felicash/personal/view/personal_page.dart';
import 'package:felicash/transaction/models/transaction_list_filter.dart';
import 'package:felicash/transaction/transaction_creation/view/transaction_creation_modal.dart';
import 'package:felicash/transaction/transaction_list/view/transactions_page.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_categories_filter_view.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_all_filters_view.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_filter_shell_modal.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_wallets_filer_view.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_types_filter_view.dart';
import 'package:felicash/transaction/transaction_list_filter/view/transaction_list_date_filter_view.dart';
import 'package:felicash/voice_transaction/view/voice_transaction_page.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/view/wallets/wallets_page.dart';
import 'package:felicash/wallet_creation/view/monetary_input_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_creation_modal.dart';
import 'package:felicash/wallet_creation/view/wallet_type_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'app_routes.dart';

/// The main router class for the application.
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
      extraCodec: const AppRouterExtraCodec(),
      routes: [
        _onboardingRoute,
        _loginRoute,
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
              routes: [_overviewRoute],
            ),
            StatefulShellBranch(
              routes: [_transactionsRoute],
            ),
            StatefulShellBranch(
              routes: [_walletsRoute],
            ),
            StatefulShellBranch(
              routes: [_personalRoute],
            ),
          ],
        ),
      ],
    );
  }

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
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

  // Base routes
  static final _onboardingRoute = GoRoute(
    name: AppRouteNames.onboarding,
    path: AppRoutes.onboarding,
    builder: (context, state) => const OnboardingPage(),
  );

  static final _loginRoute = GoRoute(
    name: AppRouteNames.login,
    path: AppRoutes.login,
    builder: (context, state) => const LoginPage(),
  );

  // Overview routes
  static final _overviewRoute = GoRoute(
    name: AppRouteNames.overview,
    path: AppRoutes.overview,
    pageBuilder: (context, state) => CustomTransitionPage(
      child: const OverviewPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
    routes: [
      _transactionCreationRoute,
      _voiceTransactionRoute,
      _aiAssistantRoute,
    ],
  );

  // Transaction routes
  static final _transactionCreationRoute = GoRoute(
    path: AppRoutes.transactionCreation,
    name: AppRouteNames.transactionCreation,
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) {
      final walletId = state.uri.queryParameters['walledId'];
      return ModalPage(
        isScrollControlled: true,
        useSafeArea: true,
        child: TransactionCreationModal(
          walletId: walletId,
        ),
      );
    },
  );

  static final _voiceTransactionRoute = GoRoute(
    path: AppRoutes.voiceTransaction,
    name: AppRouteNames.voiceTransaction,
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: const VoiceTransactionPage(),
      );
    },
  );

  static final _aiAssistantRoute = GoRoute(
    path: AppRoutes.aiAssistant,
    name: AppRouteNames.aiAssistant,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) => const AiAssistantPage(),
  );

  static final _transactionsRoute = GoRoute(
    name: AppRouteNames.transactions,
    path: AppRoutes.transactions,
    pageBuilder: (context, state) => FadeTransitionPage(
      key: state.pageKey,
      child: const TransactionsPage(),
    ),
    routes: [
      _transactionListFiltersRoute,
    ],
  );

  static final _transactionListFiltersRoute = ShellRoute(
    parentNavigatorKey: _rootNavigatorKey,
    navigatorKey: _shellNavigatorKey,
    pageBuilder: (context, state, navigator) {
      return ModalSheetPage(
        swipeDismissible: true,
        viewportPadding: EdgeInsets.only(
          top: MediaQuery.viewPaddingOf(context).top,
        ),
        child: TransactionListFilterShellModal(navigator: navigator),
      );
    },
    routes: [
      GoRoute(
        name: AppRouteNames.transactionListFilters,
        path: AppRoutes.transactionListFilters,
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) {
          final initialFilter = state.extra as TransactionListFilter?;
          return PagedSheetPage(
            child: AllFiltersView(
              initialFilter: initialFilter ?? TransactionListFilter.empty,
            ),
          );
        },
        routes: [
          GoRoute(
            name: AppRouteNames.transactionListFilterCategories,
            path: AppRoutes.transactionListFilterCategories,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final initialSelected = state.extra as Set<CategoryModel>?;
              return PagedSheetPage(
                scrollConfiguration: const SheetScrollConfiguration(),
                child: TransactionListCategoriesFilterView(
                  initialSelected: initialSelected ?? {},
                ),
              );
            },
          ),
          GoRoute(
            name: AppRouteNames.transactionListFilterWallets,
            path: AppRoutes.transactionListFilterWallets,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final initialSelected = state.extra as Set<WalletViewModel>?;
              return PagedSheetPage(
                scrollConfiguration: const SheetScrollConfiguration(),
                child: TransactionListWalletsFilerView(
                  initialSelected: initialSelected ?? {},
                ),
              );
            },
          ),
          GoRoute(
            name: AppRouteNames.transactionListFilterTypes,
            path: AppRoutes.transactionListFilterTypes,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final initialSelected = state.extra as Set<TransactionTypeEnum>?;
              return PagedSheetPage(
                scrollConfiguration: const SheetScrollConfiguration(),
                child: TransactionListTypesFilterView(
                  initialSelected: initialSelected ?? {},
                ),
              );
            },
          ),
          GoRoute(
            name: AppRouteNames.transactionListFilterDate,
            path: AppRoutes.transactionListFilterDate,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final initialDates = state.extra as (DateTime?, DateTime?)?;
              return PagedSheetPage(
                scrollConfiguration: const SheetScrollConfiguration(),
                child: TransactionListDateFilterView(
                  initialFrom: initialDates?.$1,
                  initialTo: initialDates?.$2,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );

  // Wallet routes
  static final _walletsRoute = GoRoute(
    name: AppRouteNames.wallets,
    path: AppRoutes.wallets,
    pageBuilder: (context, state) => FadeTransitionPage(
      key: state.pageKey,
      child: const WalletPage(),
    ),
    routes: [
      _walletTypeSelectorRoute,
      _walletCreationRoute,
    ],
  );

  static final _walletTypeSelectorRoute = GoRoute(
    name: AppRouteNames.walletTypeSelector,
    path: AppRoutes.walletTypeSelector,
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) {
      return const ModalPage(
        isScrollControlled: false,
        child: WalletTypeSelectorModal(),
      );
    },
  );

  static final _walletCreationRoute = GoRoute(
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
        child: WalletCreationModal(
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
          final initial = state.uri.queryParameters['initial'];
          final currency = state.uri.queryParameters['currency'];
          return ModalPage(
            isScrollControlled: false,
            useSafeArea: true,
            child: MonetaryInputModal(
              initialValue: double.parse(initial!),
              currencySymbol: currency!,
            ),
          );
        },
      ),
    ],
  );

  // Personal routes
  static final _personalRoute = GoRoute(
    name: AppRouteNames.personal,
    path: AppRoutes.personal,
    pageBuilder: (context, state) => const FadeTransitionPage(
      child: PersonalPage(),
    ),
  );
}
