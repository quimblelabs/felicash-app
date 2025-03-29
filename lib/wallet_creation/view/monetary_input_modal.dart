import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/extensions/string_extension.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// {@template money_input_view}
/// The money input view.
/// {@endtemplate}
class MonetaryInputModal extends HookWidget {
  /// {@macro money_input_view}
  const MonetaryInputModal({
    required this.currencySymbol,
    this.initalValue = 0,
    super.key,
  });

  /// The currency symbol to display.
  final String currencySymbol;
  final double initalValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final controller = useTextEditingController(text: initalValue.toString());
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
                    child: Text('Update'.hardCoded),
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
