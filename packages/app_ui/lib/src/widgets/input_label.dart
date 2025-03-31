import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A label for an input.
class InputLabel extends StatelessWidget {
  /// Creates a [InputLabel].
  const InputLabel({required this.text, super.key});

  /// The text to display.
  final Widget text;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge!;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.xs,
      ),
      child: DefaultTextStyle(
        style: textStyle,
        child: text,
      ),
    );
  }
}
