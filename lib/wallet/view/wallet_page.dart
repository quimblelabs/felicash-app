import 'package:app_ui/app_ui.dart';
import 'package:felicash/wallet/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WalletView();
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallets'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: WalletTypeTabBar(),
            ),
          ),
          actions: [
            IconButton.filled(
              onPressed: () {
                context.push('/create-wallet');
              },
              color: Theme.of(context).colorScheme.onPrimary,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: WalletCard(
                block: WalletBlock(
                  id: '1',
                  name: 'Wallet 1',
                  color: Colors.blue,
                  balance: 1000,
                  currency: 'USD',
                  icon: '🏝️',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WalletTypeTabBar extends StatelessWidget {
  const WalletTypeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(IconsaxPlusBold.wallet_1),
                          const SizedBox(width: AppSpacing.md),
                          Text('Wallets'.hardCoded),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(IconsaxPlusBold.wallet_1),
                          const SizedBox(width: AppSpacing.md),
                          Text('Savings'.hardCoded),
                        ],
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
