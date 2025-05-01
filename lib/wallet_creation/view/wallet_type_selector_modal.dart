import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/routes.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';

class WalletTypeSelectorModal extends StatelessWidget {
  const WalletTypeSelectorModal({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ModalScaffold(
      header: Text(l10n.walletTypeSelectorModalTitle),
      backgroundColor: theme.colorScheme.surfaceContainer,
      content: ListTileTheme(
        data: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xlg)),
          ),
          titleTextStyle: theme.textTheme.titleMedium,
          tileColor: theme.colorScheme.surfaceContainerLowest,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.wallet),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(l10n.walletTypeSelectorModalBasicWalletTypeLabel),
                  subtitle: Text(
                    l10n.walletTypeSelectorModalBasicWalletTypeSubtitle,
                  ),
                  onTap: () => _onTap(context, WalletTypeEnum.basic),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppColors.gold.colorSchemeOf(context).colorContainer,
                    foregroundColor:
                        AppColors.gold.colorSchemeOf(context).onColorContainer,
                    radius: 24,
                    child: const Icon(Icons.credit_card),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(
                    l10n.walletTypeSelectorModalCreditWalletTypeLabel,
                  ),
                  subtitle: Text(
                    l10n.walletTypeSelectorModalCreditWalletTypeSubtitle,
                  ),
                  onTap: () => _onTap(context, WalletTypeEnum.credit),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.dollarBill
                        .colorSchemeOf(context)
                        .colorContainer,
                    foregroundColor: AppColors.dollarBill
                        .colorSchemeOf(context)
                        .onColorContainer,
                    radius: 24,
                    child: const Icon(Icons.savings),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(
                    l10n.walletTypeSelectorModalSavingsWalletTypeLabel,
                  ),
                  subtitle: Text(
                    l10n.walletTypeSelectorModalSavingsWalletTypeSubtitle,
                  ),
                  onTap: () => _onTap(context, WalletTypeEnum.savings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WalletTypeEnum walletType) async {
    unawaited(HapticFeedback.lightImpact());
    context.pop();
    // Wait for the animation to finish
    await Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      context.pushNamed(
        AppRouteNames.walletCreation,
        pathParameters: {
          'type': walletType.name,
        },
      );
    });
  }
}
