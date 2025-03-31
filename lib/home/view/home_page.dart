import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/home/cubit/home_cubit.dart';
import 'package:felicash/navigation/view/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: HomeView(child: child),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);

    return _TabChangedListener(
      child: Scaffold(
        body: child,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomNavBar(
          selectedTab,
          onTabChanged: (index) {
            context.read<HomeCubit>().changeTab(index);
          },
        ),
      ),
    );
  }
}

class _TabChangedListener extends StatelessWidget {
  const _TabChangedListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) {
        return previous.tabIndex != current.tabIndex;
      },
      listener: (context, state) {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
        final location = switch (state.tabIndex) {
          0 => AppRoutes.overview,
          1 => AppRoutes.transactions,
          2 => AppRoutes.wallets,
          3 => AppRoutes.personal,
          _ => AppRoutes.overview
        };
        context.go(location);
      },
      child: child,
    );
  }
}
