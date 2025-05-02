import 'package:app_ui/app_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:felicash/category/categories/view/horizontal_category_selector.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/transaction/bloc/transaction_creation_bloc.dart';
import 'package:felicash/transaction/transaction_creation/widgets/wallet_selector.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_models/shared_models.dart';

extension on TransactionTypeEnum {
  String name(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      TransactionTypeEnum.expense =>
        l10n.transactionCreationFormExpenseTypeLabel,
      TransactionTypeEnum.income => l10n.transactionCreationFormIncomeTypeLabel,
      TransactionTypeEnum.transfer =>
        l10n.transactionCreationFormTransferTypeLabel,
      TransactionTypeEnum.unknown =>
        l10n.transactionCreationFormUnknownTypeLabel,
    };
  }
}

class TransactionCreationForm extends StatelessWidget {
  const TransactionCreationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const _TransactionTypeSelector(),
              const SizedBox(height: AppSpacing.xlg),
              InputLabel(
                text: Text(
                  l10n.transactionCreationFormTransactionAmountFieldLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _TransactionAmount(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _WalletsSelector(),
        const SizedBox(height: AppSpacing.lg),
        InputLabel(text: Text(l10n.transactionCreationFormCategoryFieldLabel)),
        const _CategorySelector(),
        const SizedBox(height: AppSpacing.lg),
        InputLabel(text: Text(l10n.transactionCreationFormDateFieldLabel)),
        const _TransactionDate(),
        const SizedBox(height: AppSpacing.lg),
        InputLabel(text: Text(l10n.transactionCreationFormNotesFieldLabel)),
        const _TransactionNotes(),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    return HorizontalCategorySelector(
      onCategorySelected: (category) {
        if (category == null) return;
        context
            .read<TransactionCreationBloc>()
            .add(TransactionCreationCategoryChanged(category));
      },
    );
  }
}

class _TransactionTypeSelector extends HookWidget {
  const _TransactionTypeSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final type = context.select(
      (TransactionCreationBloc bloc) => bloc.state.type,
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: type,
        onChanged: (value) {
          context
              .read<TransactionCreationBloc>() //
              .add(TransactionCreationTypeChanged(value ?? type));
        },
        selectedItemBuilder: (context) {
          return TransactionTypeEnum.availableValues
              .map(
                (e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.transactionCreationFormTypeText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      e.name(context),
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              )
              .toList();
        },
        items: [
          ...TransactionTypeEnum.availableValues.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    e.icon,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    e.name(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          elevation: 0,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.xxxlg),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

class _TransactionAmount extends StatelessWidget {
  const _TransactionAmount();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return TextFormField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: theme.textTheme.displaySmall,
      decoration: InputDecoration(
        filled: false,
        hintText: l10n.transactionCreationFormEnterAmountHintText,
        hintStyle: TextStyle(
          color: theme.hintColor,
        ),
      ),
    );
  }
}

class _WalletsSelector extends StatelessWidget {
  const _WalletsSelector();

  @override
  Widget build(BuildContext context) {
    final wallet = context.select(
      (TransactionCreationBloc bloc) => bloc.state.wallet,
    );
    final transferToWallet = context.select(
      (TransactionCreationBloc bloc) => bloc.state.transferToWallet,
    );
    final isTransfer = context.select(
      (TransactionCreationBloc bloc) =>
          bloc.state.type == TransactionTypeEnum.transfer,
    );
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        return WalletSelector(
          wallet: wallet,
          toWallet: transferToWallet,
          isTransfer: isTransfer,
          onChanged: (from, to) {
            if (from != wallet) {
              context
                  .read<TransactionCreationBloc>() //
                  .add(TransactionCreationWalletChanged(wallet: wallet));
            }
            if (to != transferToWallet) {
              context
                  .read<TransactionCreationBloc>() //
                  .add(TransactionCreationTransferToWalletChanged(to));
            }
          },
        );
      },
    );
  }
}

class _TransactionDate extends HookWidget {
  const _TransactionDate();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateStr = context
        .read<TransactionCreationBloc>()
        .state //
        .date
        ?.yMMMEd(l10n.localeName);
    final controller = useTextEditingController(text: dateStr);
    return BlocListener<TransactionCreationBloc, TransactionCreationState>(
      listener: (context, state) {
        final dateStr = state.date?.yMMMEd(l10n.localeName);
        if (dateStr != null && controller.text != dateStr) {
          controller.text = dateStr;
        }
      },
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(IconsaxPlusLinear.calendar),
          suffixIcon: const Icon(Icons.arrow_forward_ios_outlined),
          hintText: l10n.transactionCreationFormEnterDateHintText,
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            locale: Locale(l10n.localeName),
          );
          if (date != null && context.mounted) {
            context
                .read<TransactionCreationBloc>()
                .add(TransactionCreationDateChanged(date));
          }
        },
      ),
    );
  }
}

class _TransactionNotes extends StatelessWidget {
  const _TransactionNotes();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxLength = context.select(
      (TransactionCreationBloc bloc) => bloc.state.note.maxLength,
    );
    return TextFormField(
      onChanged: (value) {
        context
            .read<TransactionCreationBloc>()
            .add(TransactionCreationNoteChanged(value));
      },
      decoration: InputDecoration(
        hintText: l10n.transactionCreationFormEnterNotesHintText,
      ),
      maxLines: 3,
      minLines: 3,
      maxLength: maxLength,
    );
  }
}
