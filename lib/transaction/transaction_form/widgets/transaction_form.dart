import 'package:app_ui/app_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:felicash/category/categories/view/horizontal_category_selector.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/transaction/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:felicash/transaction/transaction_form/widgets/wallet_selector.dart';
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

class TransactionForm extends StatelessWidget {
  const TransactionForm({super.key});

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
            .read<TransactionFormBloc>()
            .add(TransactionFormCategoryChanged(category));
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
      (TransactionFormBloc bloc) => bloc.state.type,
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: type,
        onChanged: (value) {
          context
              .read<TransactionFormBloc>() //
              .add(TransactionFormTypeChanged(value ?? type));
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

class _TransactionAmount extends HookWidget {
  const _TransactionAmount();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final amount = context.select(
      (TransactionFormBloc bloc) => bloc.state.amount.value,
    );
    final amountString = amount.abs().toAmountValue(locale: l10n.localeName);
    final controller = useTextEditingController(
      text: amountString,
    );

    useEffect(
      () {
        if (amountString != controller.text) {
          controller.text = amountString;
        }
        return null;
      },
      [amount],
    );

    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        final amount = double.tryParse(value);
        if (amount == null) return;
        context
            .read<TransactionFormBloc>()
            .add(TransactionFormAmountChanged(amount));
      },
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
      (TransactionFormBloc bloc) => bloc.state.wallet,
    );
    final transferToWallet = context.select(
      (TransactionFormBloc bloc) => bloc.state.transferToWallet,
    );
    final isTransfer = context.select(
      (TransactionFormBloc bloc) =>
          bloc.state.type == TransactionTypeEnum.transfer,
    );
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        return WalletSelector(
          wallet: wallet,
          toWallet: transferToWallet,
          isTransfer: isTransfer,
          onChanged: (from, to) {
            if (from != null && from != wallet) {
              context
                  .read<TransactionFormBloc>() //
                  .add(TransactionFormWalletChanged(wallet: from));
            }
            if (to != null && to != transferToWallet) {
              context
                  .read<TransactionFormBloc>() //
                  .add(TransactionFormTransferToWalletChanged(to));
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
        .read<TransactionFormBloc>()
        .state //
        .date
        ?.yMMMEd(l10n.localeName);
    final controller = useTextEditingController(text: dateStr);
    return BlocListener<TransactionFormBloc, TransactionFormState>(
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
                .read<TransactionFormBloc>()
                .add(TransactionFormDateChanged(date));
          }
        },
      ),
    );
  }
}

class _TransactionNotes extends HookWidget {
  const _TransactionNotes();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxLength = context.select(
      (TransactionFormBloc bloc) => bloc.state.note.maxLength,
    );
    final note = context.select(
      (TransactionFormBloc bloc) => bloc.state.note.value,
    );
    final controller = useTextEditingController(text: note);
    useEffect(
      () {
        void onChange(String value) {
          context
              .read<TransactionFormBloc>()
              .add(TransactionFormNoteChanged(value));
        }

        controller.addListener(() {
          final value = controller.text;
          if (value != note) {
            onChange(value);
          }
        });
        return null;
      },
      [controller],
    );
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.transactionCreationFormEnterNotesHintText,
      ),
      maxLines: 3,
      minLines: 3,
      maxLength: maxLength,
    );
  }
}
