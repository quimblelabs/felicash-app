import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/category/creation/bloc/category_creation_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shared_models/shared_models.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class CategoryCreationModal extends StatelessWidget {
  const CategoryCreationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return BlocProvider(
      create: (context) => CategoryCreationBloc(
        transactionType: TransactionTypeEnum.expense,
        categoryRepository: context.read(),
        color: primary,
      ),
      child: const _CategoryCreationModalContent(),
    );
  }
}

class _CategoryCreationModalContent extends StatelessWidget {
  const _CategoryCreationModalContent();

  @override
  Widget build(BuildContext context) {
    return Sheet(
      initialOffset: const SheetOffset(.6),
      snapGrid: const SheetSnapGrid(
        snaps: [
          SheetOffset(0.6),
          SheetOffset(.8),
        ],
        minFlingSpeed: 0.5,
      ),
      scrollConfiguration: const SheetScrollConfiguration(),
      decoration: MaterialSheetDecoration(
        size: SheetSize.stretch,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xlg),
        ),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SafeArea(
        child: SheetContentScaffold(
          bottomBarVisibility: const BottomBarVisibility.always(),
          topBar: AppBar(
            title: Text('Create Category'.hardCoded),
            automaticallyImplyLeading: false,
            actions: const [ModalCloseButton()],
          ),
          body: const _CategoryCreationForm(),
          bottomBar: const _SubmitButton(),
        ),
      ),
    );
  }
}

class _CategoryCreationForm extends StatelessWidget {
  const _CategoryCreationForm();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputLabel(text: Text('Category Name'.hardCoded)),
          const Row(
            spacing: AppSpacing.md,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(),
              Expanded(
                child: _CategoryName(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _CategoryColorPicker(),
          const SizedBox(height: AppSpacing.md),
          InputLabel(
            text: Text('Category Description'.hardCoded),
          ),
          const _CategoryDescription(),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon();

  @override
  Widget build(BuildContext context) {
    final color =
        context.select((CategoryCreationBloc bloc) => bloc.state.color);
    final icon = context.select((CategoryCreationBloc bloc) => bloc.state.icon);
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
          iconPacks: const [IconPacks.category],
          doneButtonText: l10n.done,
        );
      },
    );
    if (picked == null) return;
    if (context.mounted) {
      context
          .read<CategoryCreationBloc>()
          .add(CategoryCreationIconChanged(picked));
    }
  }
}

class _CategoryName extends StatelessWidget {
  const _CategoryName();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context
        .select((CategoryCreationBloc bloc) => bloc.state.name.displayError);
    final maxLength = context.read<CategoryCreationBloc>().state.name.maxLength;
    final errorText = switch (displayError) {
      CategoryNameValidationError.empty =>
        'The category name cannot be empty'.hardCoded,
      CategoryNameValidationError.tooLong =>
        'The category name is too long'.hardCoded,
      null => null,
    };
    return TextFormField(
      maxLength: maxLength,
      onChanged: (value) {
        context
            .read<CategoryCreationBloc>()
            .add(CategoryCreationNameChanged(value));
      },
      decoration: InputDecoration(
        hintText: 'Category name'.hardCoded,
        errorText: errorText,
      ),
    );
  }
}

class _CategoryColorPicker extends StatelessWidget {
  const _CategoryColorPicker();

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
                (CategoryCreationBloc bloc) => bloc.state.color == color,
              );
              return GestureDetector(
                onTap: () {
                  context
                      .read<CategoryCreationBloc>()
                      .add(CategoryCreationColorChanged(color));
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

class _CategoryDescription extends StatelessWidget {
  const _CategoryDescription();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context.select(
      (CategoryCreationBloc bloc) => bloc.state.description.displayError,
    );
    final errorText = switch (displayError) {
      CategoryDescriptionValidationError.tooLong =>
        l10n.walletCreationFormWalletDescriptionIsTooLongErrorMessage,
      null => null,
    };
    final maxLength =
        context.read<CategoryCreationBloc>().state.description.maxLength;

    return TextFormField(
      maxLines: 3,
      minLines: 3,
      maxLength: maxLength,
      onChanged: (value) {
        context
            .read<CategoryCreationBloc>()
            .add(CategoryCreationDescriptionChanged(value));
      },
      decoration: InputDecoration(
        hintText: 'Descible your category for easier identification '
                'when using AI assistant'
            .hardCoded,
        errorText: errorText,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final isValid =
        context.select((CategoryCreationBloc bloc) => bloc.state.isValid);
    final isCreating = context.select(
      (CategoryCreationBloc bloc) =>
          bloc.state.status == CategoryCreationStatus.submiting,
    );
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xlg,
        right: AppSpacing.xlg,
        top: AppSpacing.md,
      ),
      child: FilledButton(
        onPressed: isValid
            ? () {
                context
                    .read<CategoryCreationBloc>()
                    .add(const CategoryCreationSubmitted());
              }
            : null,
        child: isCreating
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text('Create Category'.hardCoded),
      ),
    );
  }
}
