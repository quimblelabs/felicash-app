import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/view/wallets/wallets_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    required this.walletViewModel,
    super.key,
    this.selected = false,
  });
  final WalletViewModel walletViewModel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final wallet = walletViewModel.wallet;
    final currency = walletViewModel.currency;
    final balance = wallet.balance.toCurrency(
      symbol: currency.symbol,
      locale: l10n.localeName,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xlg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.xlg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: wallet.color,
                child: IconWidget(
                  icon: wallet.icon,
                  color: wallet.color.onContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  wallet.name,
                  style: theme.textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current balance'.hardCoded,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      balance,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletBlock {
  const WalletBlock({
    required this.id,
    required this.name,
    required this.color,
    required this.balance,
    required this.currency,
    required this.icon,
  });

  final String id;
  final String name;
  final Color color;
  final double balance;
  final String currency;
  final RawIconData icon;
}
