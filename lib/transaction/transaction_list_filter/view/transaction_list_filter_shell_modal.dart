import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class TransactionListFilterShellModal extends StatelessWidget {
  const TransactionListFilterShellModal({
    required this.navigator,
    super.key,
  });

  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    return PagedSheet(
      decoration: MaterialSheetDecoration(
        size: SheetSize.stretch,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xlg),
        ),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surface,
      ),
      builder: (context, child) {
        return SheetContentScaffold(
          body: child,
        );
      },
      navigator: navigator,
    );
  }
}
