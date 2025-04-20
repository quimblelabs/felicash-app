import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:felicash/currency/bloc/currencies_bloc.dart';
import 'package:felicash/currency/views/currency_selector/currency_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CurrencySelector extends HookWidget {
  const CurrencySelector({
    super.key,
    this.initialCurrency,
    this.onCurrencySelected,
  });

  final CurrencyModel? initialCurrency;
  final ValueChanged<CurrencyModel?>? onCurrencySelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrenciesBloc, CurrenciesState>(
      listener: (context, state) {
        if (state is CurrenciesLoadSuccess) {
          onCurrencySelected?.call(state.currencies.first);
        }
      },
      child: CurrencySelectorView(
        initialCurrency: initialCurrency,
        onCurrencySelected: onCurrencySelected,
      ),
    );
  }
}

class CurrencySelectorView extends HookWidget {
  const CurrencySelectorView({
    super.key,
    this.initialCurrency,
    this.onCurrencySelected,
  });

  final CurrencyModel? initialCurrency;
  final ValueChanged<CurrencyModel?>? onCurrencySelected;

  Widget _buildCurrencyIcon(BuildContext context, CurrenciesState state) {
    return switch (state) {
      CurrenciesInitial() ||
      CurrenciesLoadInProgress() =>
        const CircularProgressIndicator(),
      CurrenciesLoadSuccess() => const Icon(Icons.arrow_drop_down),
      CurrenciesLoadFailure(:final previousQuery) => GestureDetector(
          onTap: () => context.read<CurrenciesBloc>().add(
                CurrenciesSubscriptionRetry(
                  query: previousQuery,
                ),
              ),
          child: const Icon(Icons.refresh),
        ),
    };
  }

  String _buildHintText(BuildContext context, CurrenciesState state) {
    return switch (state) {
      CurrenciesInitial() => 'Currency'.hardCoded,
      CurrenciesLoadInProgress(:final messageText) => messageText,
      CurrenciesLoadSuccess(:final currencies) => currencies.first.code,
      CurrenciesLoadFailure(:final messageText) => messageText,
    };
  }

  TextStyle _buildHintStyle(BuildContext context, CurrenciesState state) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge;
    return switch (state) {
      CurrenciesInitial() || CurrenciesLoadInProgress() => style!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      CurrenciesLoadSuccess() => style!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      CurrenciesLoadFailure() => style!.copyWith(
          color: theme.colorScheme.error,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.select<CurrenciesBloc, List<CurrencyModel>>(
      (bloc) => switch (bloc.state) {
        CurrenciesLoadSuccess(:final currencies) => currencies,
        _ => [],
      },
    );
    final currencyController =
        useTextEditingController(text: initialCurrency?.code);
    return TextFormField(
      controller: currencyController,
      readOnly: true,
      onTap: () async {
        final selected = await _pickCurrency(
          context,
          currencies,
          initialCurrency,
        );
        if (selected != null) {
          currencyController.text = selected.code;
          onCurrencySelected?.call(selected);
        }
      },
      decoration: InputDecoration(
        hintText: context.select<CurrenciesBloc, String>(
          (bloc) => _buildHintText(context, bloc.state),
        ),
        hintStyle: context.select<CurrenciesBloc, TextStyle>(
          (bloc) => _buildHintStyle(context, bloc.state),
        ),
        suffixIcon: BlocBuilder<CurrenciesBloc, CurrenciesState>(
          builder: _buildCurrencyIcon,
        ),
      ),
    );
  }

  Future<CurrencyModel?> _pickCurrency(
    BuildContext context,
    List<CurrencyModel> currencies,
    CurrencyModel? initialCurrency,
  ) async {
    unawaited(HapticFeedback.lightImpact());
    final picked = await showModalBottomSheet<CurrencyModel?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CurrencySelectorModal(
          title: 'Pick a currency'.hardCoded,
          currencyPack: currencies,
          initialCurrency: initialCurrency,
        );
      },
    );
    if (picked == null) return initialCurrency;
    if (context.mounted) {
      return picked;
    }
    return null;
  }
}
