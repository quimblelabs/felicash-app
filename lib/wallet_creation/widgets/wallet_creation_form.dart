import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/currency/views/currency_selector/currency_selector.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/wallet_creation/bloc/wallet_creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';

class WalletCreationForm extends StatelessWidget {
  const WalletCreationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final walletType = context.read<WalletCreationBloc>().state.walletType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(text: Text(l10n.walletCreationFormWalletNameFieldLabel)),
        const Row(
          spacing: AppSpacing.md,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WalletIcon(),
            Expanded(
              child: _WalletName(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const _WalletColorPicker(),
        const SizedBox(height: AppSpacing.md),
        InputLabel(
          text: Text(l10n.walletCreationFormWalletDescriptionFieldLabel),
        ),
        const _WalletDescription(),
        const SizedBox(height: AppSpacing.md),
        InputLabel(text: Text(l10n.walletCreationFormWalletCurrencyFieldLabel)),
        const _WalletCurrency(),
        const SizedBox(height: AppSpacing.md),
        InputLabel(text: Text(l10n.walletCreationFormWalletBalanceFieldLabel)),
        const _WalletBalance(),
        if (walletType == WalletTypeEnum.credit) ...[
          const SizedBox(height: AppSpacing.md),
          InputLabel(
            text: Text(l10n.walletCreationFormWalletCreditLimitFieldLabel),
          ),
          const _WalletCreditLimit(),
          const SizedBox(height: AppSpacing.md),
          const _WalletStateDayOfMonth(),
          const SizedBox(height: AppSpacing.md),
          const _WalletPaymentDayOfMonth(),
        ] else if (walletType == WalletTypeEnum.savings) ...[
          const SizedBox(height: AppSpacing.md),
          InputLabel(
            text: Text(l10n.walletCreationFormWalletSavingsGoalFieldLabel),
          ),
          const _WalletSavingsGoal(),
        ],
        const SizedBox(height: AppSpacing.md),
        const _ExclueFromToal(),
      ],
    );
  }
}

class _WalletIcon extends StatelessWidget {
  const _WalletIcon();

  @override
  Widget build(BuildContext context) {
    final color = context.select((WalletCreationBloc bloc) => bloc.state.color);
    final icon = context.select((WalletCreationBloc bloc) => bloc.state.icon);
    final foregroundColor = color.onContainer;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: GestureDetector(
        onTap: () => _pickIcon(context),
        child: CircleAvatar(
          radius: AppRadius.xlg,
          backgroundColor: color,
          foregroundColor: foregroundColor,
          child: Icon(icon),
        ),
      ),
    );
  }

  Future<void> _pickIcon(BuildContext context) async {
    final l10n = context.l10n;
    unawaited(HapticFeedback.lightImpact());
    final picked = await showModalBottomSheet<IconData?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return IconPickerModal(
          title: Text(l10n.walletCreationFormWalletPickAnIconText),
          iconPacks: const [IconPacks.wallets],
          doneButtonText: l10n.done,
        );
      },
    );
    if (picked == null) return;
    if (context.mounted) {
      context.read<WalletCreationBloc>().add(WalletCreationIconChanged(picked));
    }
  }
}

class _WalletName extends StatelessWidget {
  const _WalletName();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context
        .select((WalletCreationBloc bloc) => bloc.state.name.displayError);
    final maxLength = context.read<WalletCreationBloc>().state.name.maxLength;
    final errorText = switch (displayError) {
      WalletNameValidationError.empty =>
        l10n.walletCreationFormWalletWalletNameIsRequiredErrorMessage,
      WalletNameValidationError.tooLong =>
        l10n.walletCreationFormWalletWalletNameIsTooLongErrorMessage,
      null => null,
    };
    return TextFormField(
      maxLength: maxLength,
      onChanged: (value) {
        context
            .read<WalletCreationBloc>()
            .add(WalletCreationNameChanged(value));
      },
      decoration: InputDecoration(
        hintText: l10n.walletCreationFormWalletNameFieldHintText,
        errorText: errorText,
      ),
    );
  }
}

class _WalletColorPicker extends StatelessWidget {
  const _WalletColorPicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorSet = [
      theme.colorScheme.secondaryFixed,
      Colors.amber,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final color = colorSet[index];

          return Builder(
            builder: (context) {
              final isSelected = context.select(
                (WalletCreationBloc bloc) => bloc.state.color == color,
              );
              return GestureDetector(
                onTap: () {
                  context
                      .read<WalletCreationBloc>()
                      .add(WalletCreationColorChanged(color));
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.onContainer,
                          )
                        : null,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: AppSpacing.md);
        },
        itemCount: colorSet.length,
      ),
    );
  }
}

class _WalletDescription extends StatelessWidget {
  const _WalletDescription();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.description.displayError,
    );
    final errorText = switch (displayError) {
      WalletDescriptionValidationError.tooLong =>
        l10n.walletCreationFormWalletDescriptionIsTooLongErrorMessage,
      null => null,
    };
    final maxLength =
        context.read<WalletCreationBloc>().state.description.maxLength;

    return TextFormField(
      maxLines: 3,
      minLines: 3,
      maxLength: maxLength,
      onChanged: (value) {
        context
            .read<WalletCreationBloc>()
            .add(WalletCreationDescriptionChanged(value));
      },
      decoration: InputDecoration(
        hintText: l10n.walletCreationFormWalletDescriptionFieldHintText,
        errorText: errorText,
      ),
    );
  }
}

class _WalletCurrency extends HookWidget {
  const _WalletCurrency();

  @override
  Widget build(BuildContext context) {
    final currency = context.select<WalletCreationBloc, CurrencyModel?>(
      (bloc) => bloc.state.currency,
    );
    return CurrencySelector(
      initialCurrency: currency,
      onCurrencySelected: (currency) {
        if (currency != null) {
          context
              .read<WalletCreationBloc>()
              .add(WalletCreationCurrencyChanged(currency));
        }
      },
    );
  }
}

class _WalletBalance extends HookWidget {
  const _WalletBalance();

  String _buildPrefixText(BuildContext context, WalletCreationState state) {
    return '${state.currency?.symbol ?? '?'} ';
  }

  TextStyle _buildPrefixStyle(BuildContext context, WalletCreationState state) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge;
    return style!.copyWith(color: theme.colorScheme.onSurfaceVariant);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final acceptedRange =
        context.read<WalletCreationBloc>().state.balance.acceptedRange;
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.balance.displayError,
    );
    final initialBalance =
        context.read<WalletCreationBloc>().state.balance.value;
    final balanceTextEditingController =
        useTextEditingController(text: initialBalance.toString());

    final errorText = switch (displayError) {
      WalletMonetaryBalanceValidationError.over =>
        l10n.walletCreationFormWalletBalanceMustBeLessThanMaxErrorMessage(
          acceptedRange.max,
        ),
      WalletMonetaryBalanceValidationError.under =>
        l10n.walletCreationFormWalletBalanceMustBeGreaterThanMinErrorMessage(
          acceptedRange.min,
        ),
      null => null,
    };

    return BlocListener<WalletCreationBloc, WalletCreationState>(
      listener: (context, state) {
        final value = state.balance.value.toString();
        if (value != balanceTextEditingController.text) {
          balanceTextEditingController.text = value;
        }
      },
      child: TextFormField(
        controller: balanceTextEditingController,
        onTap: () => _updateBalance(context),
        readOnly: true,
        decoration: InputDecoration(
          prefixText: context.select<WalletCreationBloc, String>(
            (bloc) => _buildPrefixText(context, bloc.state),
          ),
          prefixStyle: context.select<WalletCreationBloc, TextStyle>(
            (bloc) => _buildPrefixStyle(context, bloc.state),
          ),
          hintText: l10n.walletCreationFormWalletBalanceFieldHintText,
          errorText: errorText,
          suffixIcon: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Future<void> _updateBalance(BuildContext context) async {
    unawaited(HapticFeedback.lightImpact());
    final curency = context.read<WalletCreationBloc>().state.currency;
    final initial = context.read<WalletCreationBloc>().state.balance.value;
    final type = context.read<WalletCreationBloc>().state.walletType;

    final updated = await context.pushNamed<double?>(
      AppRouteNames.balanceUpdate,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency?.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context
          .read<WalletCreationBloc>()
          .add(WalletCreationBalanceChanged(updated));
    }
  }
}

class _ExclueFromToal extends StatelessWidget {
  const _ExclueFromToal();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        0,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.walletCreationFormWalletExcludeFromTotalCheckboxLabel,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          BlocSelector<WalletCreationBloc, WalletCreationState, bool>(
            selector: (state) => state.excludeFromTotal,
            builder: (context, value) {
              return Switch.adaptive(
                value: value,
                onChanged: (value) {
                  context
                      .read<WalletCreationBloc>()
                      .add(WalletCreationExcludeFromTotalChanged(value));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Credit Wallet Creation ---
class _WalletCreditLimit extends HookWidget {
  const _WalletCreditLimit();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final acceptedRange =
        context.read<WalletCreationBloc>().state.creditLimit.acceptedRange;
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.creditLimit.displayError,
    );
    final creditLimit =
        context.read<WalletCreationBloc>().state.creditLimit.value;
    final balanceTextEditingController =
        useTextEditingController(text: creditLimit.toString());

    final errorText = switch (displayError) {
      WalletCreditLimitValidationError.over =>
        l10n.walletCreationFormCreditLimitMustBeLessThanMaxErrorMessage(
          acceptedRange.max,
        ),
      WalletCreditLimitValidationError.under =>
        l10n.walletCreationFormCreditLimitMustBeGreaterThanMinErrorMessage(
          acceptedRange.min,
        ),
      WalletCreditLimitValidationError.canNotBeZero =>
        l10n.walletCreationFormCreditLimitMustBeGreaterThanZeroErrorMessage,
      null => null,
    };

    final currencySymbol = context.select(
      (WalletCreationBloc bloc) => bloc.state.currency?.symbol,
    );

    return BlocListener<WalletCreationBloc, WalletCreationState>(
      listener: (context, state) {
        final value = state.creditLimit.value.toString();
        if (value != balanceTextEditingController.text) {
          balanceTextEditingController.text = value;
        }
      },
      child: TextFormField(
        controller: balanceTextEditingController,
        onTap: () => _updateBalance(context),
        readOnly: true,
        decoration: InputDecoration(
          prefixText: '$currencySymbol ',
          hintText: l10n.walletCreationFormCreditLimitFieldHintText,
          errorText: errorText,
          suffixIcon: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Future<void> _updateBalance(BuildContext context) async {
    unawaited(HapticFeedback.lightImpact());
    final curency = context.read<WalletCreationBloc>().state.currency;
    final initial = context.read<WalletCreationBloc>().state.creditLimit.value;
    final type = context.read<WalletCreationBloc>().state.walletType;

    final updated = await context.pushNamed<double?>(
      AppRouteNames.balanceUpdate,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency?.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context
          .read<WalletCreationBloc>()
          .add(WalletCreationCreditLimitChanged(updated));
    }
  }
}

class _WalletStateDayOfMonth extends StatelessWidget {
  const _WalletStateDayOfMonth();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final range =
        context.read<WalletCreationBloc>().state.stateDayOfMonth.acceptedRange;
    final items = List.generate(
      range.max - range.min + 1,
      (index) => DropdownMenuItem<int>(
        value: range.min + index,
        child: Text(
          '${range.min + index}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.walletCreationFormCreditWalletDayOfMonthText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          BlocSelector<WalletCreationBloc, WalletCreationState, int>(
            selector: (state) => state.stateDayOfMonth.value,
            builder: (context, value) {
              return DropdownButton<int>(
                value: value,
                items: items,
                onChanged: (value) {
                  context
                      .read<WalletCreationBloc>()
                      .add(WalletCreationStateDayOfMonthChanged(value!));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WalletPaymentDayOfMonth extends StatelessWidget {
  const _WalletPaymentDayOfMonth();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final range = context
        .read<WalletCreationBloc>()
        .state
        .paymentDayOfMonth
        .acceptedRange;
    final items = List.generate(
      range.max - range.min + 1,
      (index) => DropdownMenuItem<int>(
        value: range.min + index,
        child: Text(
          '${range.min + index}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.walletCreationFormCreditWalletPaymentDayOfMonthText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          BlocSelector<WalletCreationBloc, WalletCreationState, int>(
            selector: (state) => state.paymentDayOfMonth.value,
            builder: (context, value) {
              return DropdownButton<int>(
                value: value,
                items: items,
                onChanged: (value) {
                  context
                      .read<WalletCreationBloc>()
                      .add(WalletCreationPaymentDayOfMonthChanged(value!));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Savings Wallet Creation ---
class _WalletSavingsGoal extends HookWidget {
  const _WalletSavingsGoal();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final acceptedRange =
        context.read<WalletCreationBloc>().state.savingsGoal.acceptedRange;
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.savingsGoal.displayError,
    );
    final inital = context.read<WalletCreationBloc>().state.savingsGoal.value;
    final savingsGoalTextEditingController = TextEditingController(
      text: inital.toString(),
    );
    final currencySymbol = context.select(
      (WalletCreationBloc bloc) => bloc.state.currency?.symbol,
    );

    final errorText = switch (displayError) {
      WalletMonetarySavingsGoalValidationError.zero =>
        l10n.walletCreationFormSavingsGoalMustBeGreaterThanZeroErrorMessage,
      WalletMonetarySavingsGoalValidationError.over =>
        l10n.walletCreationFormSavingsGoalMustBeLessThanMaxErrorMessage(
          acceptedRange.max,
        ),
      WalletMonetarySavingsGoalValidationError.under =>
        l10n.walletCreationFormSavingsGoalMustBeGreaterThanMinErrorMessage(
          acceptedRange.min,
        ),
      null => null,
    };

    return BlocListener<WalletCreationBloc, WalletCreationState>(
      listener: (context, state) {
        final value = state.balance.value.toString();
        if (value != savingsGoalTextEditingController.text) {
          savingsGoalTextEditingController.text = value;
        }
      },
      child: TextFormField(
        controller: savingsGoalTextEditingController,
        onTap: () => _update(context),
        readOnly: true,
        decoration: InputDecoration(
          prefixText: '$currencySymbol ',
          hintText: l10n.walletCreationFormSavingsGoalFieldHintText,
          errorText: errorText,
          suffixIcon: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Future<void> _update(BuildContext context) async {
    unawaited(HapticFeedback.lightImpact());
    final curency = context.read<WalletCreationBloc>().state.currency;
    final initial = context.read<WalletCreationBloc>().state.savingsGoal.value;
    final type = context.read<WalletCreationBloc>().state.walletType;

    final updated = await context.pushNamed<double?>(
      AppRouteNames.balanceUpdate,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency?.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context
          .read<WalletCreationBloc>()
          .add(WalletCreationSavingGoalChanged(updated));
    }
  }
}
