import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// {@template money_input_view}
/// The money input view.
/// {@endtemplate}
class MonetaryInputModal extends HookWidget {
  /// {@macro money_input_view}
  const MonetaryInputModal({
    required this.currencySymbol,
    this.initialValue = 0,
    super.key,
  });

  /// The currency symbol to display.
  final String currencySymbol;
  final double initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final controller = useTextEditingController(text: initialValue.toString());
    final height = mediaQuery.size.height;
    final contentHeight = height * 0.4;
    return ModalScaffold(
      content: SizedBox(
        height: contentHeight,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xlg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: TextFormField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixText: '$currencySymbol ',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ColoredBox(
              color: theme.colorScheme.surface,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: FilledButton(
                    onPressed: () {
                      final parsed = double.tryParse(controller.text);
                      Navigator.of(context).pop(parsed);
                    },
                    child: Text(l10n.update),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
