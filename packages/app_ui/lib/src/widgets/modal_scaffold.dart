import 'package:app_ui/src/border_radius/app_radius.dart';
import 'package:app_ui/src/spacing/spacing.dart';
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
    super.key,
  });

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
    return Material(
      color: effectiveBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xlg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            //Dragger
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  title: header,
                  centerTitle: false,
                  actions: canPop
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                foregroundColor: theme.colorScheme.onSurface,
                              ),
                              onPressed: () {
                                Navigator.maybePop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ]
                      : null,
                ),
                Flexible(child: content),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
