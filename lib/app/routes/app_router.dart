import 'dart:async';

import 'package:app_utils/app_utils.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/app/home/view/home_page.dart';
import 'package:felicash/app/onboarding/view/onboarding_page.dart';
import 'package:felicash/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The paths of the routes.
abstract class AppRouter {
  static const onboarding = '/';
  static const home = '/home';
  static const login = '/login';
}

/// The names of the routes.
abstract class AppRouteNames {
  static const onboarding = 'onboarding';
  static const home = 'home';
  static const login = 'login';
}

/// Builds the router for the application.
GoRouter routerBuilder(AppBloc appBloc) {
  return GoRouter(
    initialLocation: AppRouter.onboarding,
    routes: [
      GoRoute(
        name: AppRouteNames.onboarding,
        path: AppRouter.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        name: AppRouteNames.home,
        path: AppRouter.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: AppRouteNames.login,
        path: AppRouter.login,
        builder: (context, state) => const LoginPage(),
      ),
    ],
    refreshListenable: StreamToListenable(
      [appBloc.stream.map((state) => state.status)],
    ),
    redirect: _redirect,
  );
}

FutureOr<String?> _redirect(BuildContext context, GoRouterState state) {
  final isAuthenticated = context.read<AppBloc>().state.status.isAuthenticated;
  // Redirect to the login page if the user is not authenticated, and if authenticated, do not show the login page
  if (!isAuthenticated && !state.matchedLocation.contains(AppRouter.login)) {
    return AppRouter.onboarding;
  }
  // Redirect to the home page if the user is authenticated
  else if (isAuthenticated) {
    return AppRouter.home;
  }
  return null;
}
