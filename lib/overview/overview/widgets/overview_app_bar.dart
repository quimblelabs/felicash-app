import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/currency/bloc/currencies_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_repository/wallet_repository.dart';

class OverviewAppBar extends StatelessWidget {
  const OverviewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.paddingOf(context).top;
    final collapsedHeight = (kToolbarHeight * 2) + paddingTop + AppSpacing.md;
    return SliverAppBar.large(
      centerTitle: false,
      stretch: true,
      leading: const _AppBarLeading(),
      collapsedHeight: collapsedHeight,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_rounded,
          ),
        ),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        centerTitle: false,
        title: _TotalBalance(),
        titlePadding: EdgeInsets.only(
          left: 70,
          bottom: kToolbarHeight + AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _SectionsSlider(),
      ),
    );
  }
}

class _AppBarLeading extends StatelessWidget {
  const _AppBarLeading();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UnconstrainedBox(
      child: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: AppLogo.light(
          size: AppRadius.xxlg,
          color: theme.colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}

class _TotalBalance extends StatelessWidget {
  const _TotalBalance({super.key});

  double _calculateTotalBalance(
    Set<CurrencyModel> currencies,
    Set<BaseWalletModel> wallets,
    CurrencyModel baseCurrency,
  ) {
    double totalBalance = 0;

    for (final wallet in wallets) {
      if (wallet.excludeFromTotal || wallet.isArchived) continue;

      if (wallet.baseCurrency.code == baseCurrency.code) {
        totalBalance += wallet.balance;
      } else {
        // TODO: Implement exchange rate conversion
        // For now, we'll just add the balance as is
        totalBalance += wallet.balance;
      }
    }
    return totalBalance;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final currencies = context.select<CurrenciesBloc, Set<CurrencyModel>>(
      (value) {
        final state = value.state;
        if (state is CurrenciesLoadSuccess) {
          return state.currencies.toSet();
        }
        return {};
      },
    );

    final wallets = context.select<WalletsBloc, Set<BaseWalletModel>>(
      (value) {
        final state = value.state;
        if (state is WalletLoadSuccess) {
          return state.wallets.toSet();
        }
        return {};
      },
    );

    // TODO(tuanhm): Get base currency from user settings
    // final baseCurrency = currencies.firstWhere(
    //   (currency) => currency.code == 'USD',
    //   orElse: () => currencies.first,
    // );
    final baseCurrency = CurrencyModel(
      code: 'USD',
      symbol: r'$',
      name: 'United States Dollar',
      id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final totalBalance = _calculateTotalBalance(
      currencies,
      wallets,
      baseCurrency,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Total Balance'.hardCoded,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
            height: 0.2,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              totalBalance.toCurrency(
                locale: l10n.localeName,
                symbol: r'$',
              ),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            UnconstrainedBox(
              child: IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  minimumSize: AppIconButtonSizes.smallMinimumSize,
                  maximumSize: AppIconButtonSizes.smallMaximumSize,
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.visibility_rounded,
                  size: AppRadius.lg,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionsSlider extends StatelessWidget {
  const _SectionsSlider();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _SectionButton(
            label: 'Overview'.hardCoded,
            isSelected: true,
            onTap: () {
              // Handle overview section tap
            },
          ),
          _SectionButton(
            label: 'Income'.hardCoded,
            isSelected: false,
            onTap: () {
              // Handle income section tap
            },
          ),
          _SectionButton(
            label: 'Expenses'.hardCoded,
            isSelected: false,
            onTap: () {
              // Handle expenses section tap
            },
          ),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : theme.hintColor,
          ),
        ),
      ),
    );
  }
}
