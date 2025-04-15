import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/arb/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    required this.transaction,
    super.key,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final crimsionRedColor = AppColors.crimsionRed.colorSchemeOf(context);
    final dolarBillColor = AppColors.dollarBill.colorSchemeOf(context);
    final amountColor = switch (transaction.transactionType) {
      TransactionTypeEnum.income => crimsionRedColor.color,
      TransactionTypeEnum.expense => dolarBillColor.color,
      TransactionTypeEnum.transfer => null,
      _ => null,
    };
    return Row(
      children: [
        CircleAvatar(
          radius: AppRadius.xlg,
          backgroundColor: transaction.category.color,
          foregroundColor: transaction.category.color.onContainer,
          child: IconWidget(
            icon: transaction.category.icon,
            size: AppRadius.xlg,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        transaction.category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (transaction.notes case final notes?)
                      if (notes.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          notes,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.amount.toCurrency(locale: l10n.localeName),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: amountColor),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    transaction.transactionDate.yMMMEd(l10n.localeName),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
