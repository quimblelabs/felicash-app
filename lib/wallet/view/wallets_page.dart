import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

typedef WalletTypeData = Map<WalletTypeEnum, (String, IconData)>;

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final walletTypeData = {
      WalletTypeEnum.basic: (
        WalletTypeEnum.basic.name,
        IconsaxPlusBold.wallet_1
      ),
      WalletTypeEnum.credit: (
        WalletTypeEnum.credit.name,
        IconsaxPlusBold.wallet_2
      ),
      WalletTypeEnum.savings: (
        WalletTypeEnum.savings.name,
        Icons.savings,
      ),
    };
    return RepositoryProvider<WalletTypeData>(
      create: (context) => walletTypeData,
      child: BlocProvider<WalletsBloc>(
        create: (context) => WalletsBloc(
          walletRepository: context.read(),
        )..add(
            WalletsWalletTypeChanged(walletType: walletTypeData.keys.first),
          ),
        child: const WalletView(),
      ),
    );
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletTypeData = context.read<WalletTypeData>();
    return DefaultTabController(
      length: walletTypeData.length,
      child: Scaffold(
        appBar: AppBar(
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
        body: BlocBuilder<WalletsBloc, WalletsState>(
          builder: (context, state) => switch (state) {
            WalletLoadInProgress() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            WalletLoadSuccess() => const _ListWalletBuilder(),
            WalletLoadFailure() => Center(
                child: Text(state.messageText),
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

class _ListWalletBuilder extends StatelessWidget {
  const _ListWalletBuilder();

  @override
  Widget build(BuildContext context) {
    final wallets = context.select<WalletsBloc, List<BaseWalletModel>>(
      (bloc) => bloc.state is WalletLoadSuccess
          ? (bloc.state as WalletLoadSuccess).wallets
          : const [],
    );
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
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
    final walletsBloc = context.read<WalletsBloc>();
    final walletTypeData = context.read<WalletTypeData>();
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
                onTap: (index) => walletsBloc.add(
                  WalletsWalletTypeChanged(
                    walletType: walletTypeData.keys.elementAt(index),
                  ),
                ),
                tabs: [
                  ...walletTypeData.entries.map(
                    (entry) => Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(entry.value.$2),
                            const SizedBox(width: AppSpacing.md),
                            Text(entry.value.$1.hardCoded),
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
