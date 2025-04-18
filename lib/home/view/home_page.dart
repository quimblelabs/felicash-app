import 'package:app_utils/app_utils.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/home/cubit/home_cubit.dart';
import 'package:felicash/navigation/view/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// The children (branch Navigators) to display in a custom container
  /// ([AnimatedBranchContainer]).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: HomeView(
        navigationShell: navigationShell,
        children: children,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// The children (branch Navigators) to display in a custom container
  /// ([AnimatedBranchContainer]).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _TabChangedListener(
      child: Scaffold(
        body: AnimatedBranchContainer(
          currentIndex: navigationShell.currentIndex,
          children: children,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomNavBar(
          navigationShell.currentIndex,
          onTabChanged: (index) {
            context.read<HomeCubit>().changeTab(index);
          },
        ),
      ),
    );
  }
}

/// Custom branch Navigator container that provides animated transitions
/// when switching branches.
class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return AnimatedScale(
            alignment: Alignment.topCenter,
            scale: index == currentIndex ? 1 : 1.008,
            duration: duration,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: index == currentIndex ? 1 : 0,
              duration: duration,
              curve: Curves.easeInOut,
              child: _branchNavigatorWrapper(index, navigator),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) {
    return IgnorePointer(
      ignoring: index != currentIndex,
      child: TickerMode(
        enabled: index == currentIndex,
        child: navigator,
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
