import 'package:app_ui/src/border_radius/app_radius.dart';
import 'package:app_ui/src/spacing/spacing.dart';
import 'package:app_ui/src/widgets/modal_close_button.dart';
import 'package:flutter/material.dart';

/// {@template modal_sheet}
/// A modal sheet.
/// {@endtemplate}
class ModalScaffold extends StatelessWidget {
  /// {@macro modal_sheet}
  const ModalScaffold({
    required this.content,
    this.header,
    this.backgroundColor,
    this.automaticallyImplyPopBack = true,
    super.key,
  });

  /// Whether to automatically imply a close button
  /// in the app bar.
  ///
  /// Defaults to `true`.
  final bool automaticallyImplyPopBack;

  /// The title of the modal sheet.
  final Widget? header;

  /// The content of the modal sheet.
  final Widget content;

  /// The background color of the modal sheet.
  ///
  // ignore: comment_references
  /// Defaults to [ThemeData.colorScheme.surface]
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.canPop(context);
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.surface;
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -AppSpacing.md,
          child: Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(AppRadius.xlg),
              ),
            ),
          ),
        ),
        Material(
          clipBehavior: Clip.hardEdge,
          color: effectiveBgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xlg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Theme(
              data: theme.copyWith(
                appBarTheme: AppBarTheme(
                  centerTitle: false,
                  titleSpacing: AppSpacing.lg,
                  toolbarHeight: kToolbarHeight + AppSpacing.md,
                  color: theme.colorScheme.surface,
                  scrolledUnderElevation: 0,
                  elevation: 0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (header != null || automaticallyImplyPopBack)
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: header,
                      actions: canPop ? [const ModalCloseButton()] : null,
                    ),
                  Flexible(child: content),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
