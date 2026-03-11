import 'package:app_ui/src/spacing/spacing.dart';
import 'package:flutter/material.dart';

/// {@template modal_close_button}
/// A button that closes the modal.
/// {@endtemplate}
class ModalCloseButton extends StatelessWidget {
  /// {@macro modal_close_button}
  const ModalCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        onPressed: () async {
          final result = await Navigator.maybePop(context);
          if (!result && context.mounted) {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.close),
      ),
    );
  }
}
