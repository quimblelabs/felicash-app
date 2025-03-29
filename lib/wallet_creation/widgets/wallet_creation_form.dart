import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:felicash/wallet_creation/bloc/wallet_creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_repository/wallet_repository.dart' show WalletTypeEnum;

class WalletCreationForm extends StatelessWidget {
  const WalletCreationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final walletType = context.read<WalletCreationBloc>().state.walletType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(text: Text('Wallet name'.hardCoded)),
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
        InputLabel(text: Text('Wallet description'.hardCoded)),
        const _WalletDescription(),
        const SizedBox(height: AppSpacing.md),
        InputLabel(text: Text('Currency'.hardCoded)),
        const _WalletCurrency(),
        const SizedBox(height: AppSpacing.md),
        InputLabel(text: Text('Balance'.hardCoded)),
        const _WalletBalance(),
        if (walletType == WalletTypeEnum.credit) ...[
          const SizedBox(height: AppSpacing.md),
          InputLabel(text: Text('Credit limit'.hardCoded)),
          const _WalletCreditLimit(),
          const SizedBox(height: AppSpacing.md),
          const _WalletStateDayOfMonth(),
          const SizedBox(height: AppSpacing.md),
          const _WalletPaymentDayOfMonth(),
        ] else if (walletType == WalletTypeEnum.savings) ...[
          const SizedBox(height: AppSpacing.md),
          InputLabel(text: Text('Savings goal'.hardCoded)),
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
    unawaited(HapticFeedback.lightImpact());
    final picked = await showModalBottomSheet<IconData?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return IconPickerModal(
          title: Text('Pick an icon'.hardCoded),
          iconPacks: const [IconPacks.wallets],
        );
      },
    );
    if (picked == null) return;
    if (context.mounted) {
      context.read<WalletCreationBloc>().add(WalletIconChanged(picked));
    }
  }
}

class _WalletName extends StatelessWidget {
  const _WalletName();

  @override
  Widget build(BuildContext context) {
    final displayError = context
        .select((WalletCreationBloc bloc) => bloc.state.name.displayError);
    final maxLength = context.read<WalletCreationBloc>().state.name.maxLength;
    final errorText = switch (displayError) {
      WalletNameValidationError.empty => 'Wallet name is required'.hardCoded,
      WalletNameValidationError.tooLong => 'Wallet name is too long'.hardCoded,
      null => null,
    };
    return TextFormField(
      maxLength: maxLength,
      onChanged: (value) {
        context.read<WalletCreationBloc>().add(WalletNameChanged(value));
      },
      decoration: InputDecoration(
        hintText: 'Name your wallet'.hardCoded,
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
                      .add(WalletColorChanged(color));
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
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.description.displayError,
    );
    final errorText = switch (displayError) {
      WalletDescriptionValidationError.tooLong =>
        'Wallet description is too long'.hardCoded,
      null => null,
    };
    final maxLength =
        context.read<WalletCreationBloc>().state.description.maxLength;

    return TextFormField(
      maxLines: 3,
      minLines: 3,
      maxLength: maxLength,
      onChanged: (value) {
        context.read<WalletCreationBloc>().add(WalletDescriptionChanged(value));
      },
      decoration: InputDecoration(
        hintText: 'Describe your wallet for easier identification'.hardCoded,
        errorText: errorText,
      ),
    );
  }
}

class _WalletCurrency extends HookWidget {
  const _WalletCurrency();

  @override
  Widget build(BuildContext context) {
    final currency = context.read<WalletCreationBloc>().state.currency;
    final currencyController = useTextEditingController(text: currency.code);
    return BlocListener<WalletCreationBloc, WalletCreationState>(
      listener: (context, state) {
        if (state.currency != currency) {
          currencyController.text = state.currency.code;
        }
      },
      child: TextFormField(
        controller: currencyController,
        readOnly: true,
        onTap: () => _pickCurrency(context),
        decoration: InputDecoration(
          hintText: 'Currency'.hardCoded,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  Future<void> _pickCurrency(BuildContext context) async {
    //TODO: add currency picker
    // unawaited(HapticFeedback.lightImpact());
    // final picked = await showModalBottomSheet<Currency?>(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return CurrencyPickerModal(
    //       title: Text('Pick a currency'.hardCoded),
    //       currencyPacks: const [CurrencyPacks.currencies],
    //     );
    //   },
    // );
    // if (picked == null) return;
    // if (context.mounted) {
    //   context.read<WalletCreationBloc>().add(WalletCurrencyChanged(picked));
    // }
  }
}

class _WalletBalance extends HookWidget {
  const _WalletBalance();

  @override
  Widget build(BuildContext context) {
    final acceptedRange =
        context.read<WalletCreationBloc>().state.balance.acceptedRange;
    final displayError = context.select(
      (WalletCreationBloc bloc) => bloc.state.balance.displayError,
    );
    final initalBalance =
        context.read<WalletCreationBloc>().state.balance.value;
    final balanceTextEditingController =
        useTextEditingController(text: initalBalance.toString());

    final errorText = switch (displayError) {
      MonetaryAmountValidationError.over =>
        'Balance must be less than ${acceptedRange.max}'.hardCoded,
      MonetaryAmountValidationError.under =>
        'Balance must be greater than ${acceptedRange.min}'.hardCoded,
      null => null,
    };

    final currencySymbol = context.select(
      (WalletCreationBloc bloc) => bloc.state.currency.symbol,
    );

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
          prefixText: '$currencySymbol ',
          hintText: 'Set the current balance'.hardCoded,
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
      AppRouteNames.balanceUpdation,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context.read<WalletCreationBloc>().add(WalletBalanceChanged(updated));
    }
  }
}

class _ExclueFromToal extends StatelessWidget {
  const _ExclueFromToal();

  @override
  Widget build(BuildContext context) {
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
              'Exclude from total'.hardCoded,
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
                      .add(WalletExcludeFromTotalChanged(value));
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
        'The credit limit must be less than ${acceptedRange.max}'.hardCoded,
      WalletCreditLimitValidationError.under =>
        'The credit limit must be greater than ${acceptedRange.min}'.hardCoded,
      WalletCreditLimitValidationError.canNotBeZero =>
        'The credit limit must be greater than 0'.hardCoded,
      null => null,
    };

    final currencySymbol = context.select(
      (WalletCreationBloc bloc) => bloc.state.currency.symbol,
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
          hintText: 'Set the credit limit'.hardCoded,
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
      AppRouteNames.balanceUpdation,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context.read<WalletCreationBloc>().add(WalletCreditLimitChanged(updated));
    }
  }
}

class _WalletStateDayOfMonth extends StatelessWidget {
  const _WalletStateDayOfMonth({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Day of month'.hardCoded,
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
                      .add(WalletStateDayOfMonthChanged(value!));
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
  const _WalletPaymentDayOfMonth({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Payment day of month'.hardCoded,
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
                      .add(WalletPaymentDayOfMonthChanged(value!));
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
      (WalletCreationBloc bloc) => bloc.state.currency.symbol,
    );

    final errorText = switch (displayError) {
      MonetaryAmountValidationError.over =>
        'The credit limit must be less than ${acceptedRange.max}'.hardCoded,
      MonetaryAmountValidationError.under =>
        'The credit limit must be greater than ${acceptedRange.min}'.hardCoded,
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
          hintText: 'Set the credit limit'.hardCoded,
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
      AppRouteNames.balanceUpdation,
      pathParameters: {'type': type.name},
      queryParameters: {
        'initial': initial.toString(),
        'currency': curency.code,
      },
    );
    if (updated == null) return;
    if (context.mounted) {
      context.read<WalletCreationBloc>().add(WalletSavingGoalChanged(updated));
    }
  }
}
