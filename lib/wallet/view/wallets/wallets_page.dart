import 'package:app_ui/app_ui.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/wallet/cubit/wallets_filter_cubit.dart';
import 'package:felicash/wallet/models/wallets_view_filter.dart';
import 'package:felicash/wallet/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_models/shared_models.dart';

extension on WalletTypeEnum {
  IconData get icon => switch (this) {
        WalletTypeEnum.basic => IconsaxPlusBold.wallet_1,
        WalletTypeEnum.credit => IconsaxPlusBold.wallet_2,
        WalletTypeEnum.savings => Icons.savings,
      };
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletsFilterCubit>(
      create: (context) => WalletsFilterCubit()
        ..onFilterChanged(
          WalletsViewFilter(
            walletTypeEnum: WalletTypeEnum.values.first,
          ),
        ),
      child: const WalletView(),
    );
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletsState = context.watch<WalletsBloc>().state;
    return DefaultTabController(
      length: WalletTypeEnum.values.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Wallets'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _WalletTypeTabBar(),
            ),
          ),
          actions: [
            IconButton.filled(
              onPressed: () =>
                  context.pushNamed(AppRouteNames.walletTypeSelector),
              color: Theme.of(context).colorScheme.onPrimary,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: switch (walletsState) {
          WalletLoadInProgress() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          WalletLoadSuccess() => const _ListWalletBuilder(),
          WalletLoadFailure() => Center(
              child: Text(walletsState.messageText),
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _ListWalletBuilder extends StatelessWidget {
  const _ListWalletBuilder();

  @override
  Widget build(BuildContext context) {
    final wallets =
        (context.watch<WalletsBloc>().state as WalletLoadSuccess).wallets;
    final filter = context.select<WalletsFilterCubit, WalletsViewFilter>(
      (cubit) => cubit.state.filter,
    );
    final filteredWallets = filter.applyAll(wallets).toList();
    return ListView.builder(
      itemCount: filteredWallets.length,
      itemBuilder: (context, index) {
        final wallet = filteredWallets[index];
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: WalletCard(
            block: WalletBlock(
              id: wallet.id,
              name: wallet.name,
              color: wallet.color,
              balance: wallet.balance,
              currency: wallet.baseCurrency.code,
              icon: wallet.icon,
            ),
          ),
        );
      },
    );
  }
}

class _WalletTypeTabBar extends StatelessWidget {
  const _WalletTypeTabBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletsFilterCubit = context.read<WalletsFilterCubit>();
    final filter = context.select<WalletsFilterCubit, WalletsViewFilter>(
      (cubit) => cubit.state.filter,
    );
    return TabBarTheme(
      data: TabBarThemeData(
        splashFactory: NoSplash.splashFactory,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.outline,
        tabAlignment: TabAlignment.center,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
          color: theme.colorScheme.primary,
        ),
      ),
      child: SizedBox(
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
          child: ColoredBox(
            color: theme.colorScheme.surfaceContainerHighest,
            child: UnconstrainedBox(
              child: TabBar(
                enableFeedback: true,
                isScrollable: true,
                onTap: (index) => walletsFilterCubit.onFilterChanged(
                  filter.copyWith(
                    walletTypeEnum: () => WalletTypeEnum.values[index],
                  ),
                ),
                tabs: [
                  ...WalletTypeEnum.values.map(
                    (entry) => Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(entry.icon),
                            const SizedBox(width: AppSpacing.md),
                            Text(entry.name.hardCoded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
