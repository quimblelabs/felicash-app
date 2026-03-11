import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/arb/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    required this.transaction,
    this.showWalletName = true,
    this.onTap,
    super.key,
  });

  final TransactionModel transaction;
  final bool showWalletName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final crimsionRedColor = AppColors.crimsionRed.colorSchemeOf(context);
    final dollarBillColor = AppColors.dollarBill.colorSchemeOf(context);
    final amountColor = switch (transaction.transactionType) {
      TransactionTypeEnum.income => dollarBillColor.color,
      TransactionTypeEnum.expense => crimsionRedColor.color,
      TransactionTypeEnum.transfer => null,
      _ => null,
    };
    final category = transaction.category;
    return ListTile(
      onTap: onTap,
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        radius: AppRadius.xlg,
        backgroundColor: category?.color.withAlpha(40),
        foregroundColor: category?.color,
        child: category != null
            ? IconWidget(icon: category.icon, size: AppRadius.xlg)
            : const Icon(Icons.question_mark),
      ),
      title: Text(category?.name ?? 'No category'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.notes ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          if (showWalletName)
            Text(
              transaction.wallet.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.amount.toCurrency(
              locale: l10n.localeName,
              symbol: transaction.wallet.currencyCode,
            ),
            style: theme.textTheme.titleMedium?.copyWith(color: amountColor),
          ),
          Text(
            transaction.transactionDate.yMMMd(l10n.localeName),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
