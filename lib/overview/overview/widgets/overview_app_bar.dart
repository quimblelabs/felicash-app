import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:flutter/material.dart';

class OverviewAppBar extends StatelessWidget {
  const OverviewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.paddingOf(context).top;
    final collapsedHeight = (kToolbarHeight * 2) + paddingTop + AppSpacing.md;
    return SliverAppBar.large(
      centerTitle: false,
      stretch: true,
      leading: const _AppBarLeading(),
      collapsedHeight: collapsedHeight,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_rounded,
          ),
        ),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        centerTitle: false,
        title: _TotalBalance(),
        titlePadding: EdgeInsets.only(
          left: 70,
          bottom: kToolbarHeight + AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _SectionsSlider(),
      ),
    );
  }
}

class _AppBarLeading extends StatelessWidget {
  const _AppBarLeading();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UnconstrainedBox(
      child: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: AppLogo.light(
          size: AppRadius.xxlg,
          color: theme.colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}

class _TotalBalance extends StatelessWidget {
  const _TotalBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Total Balance'.hardCoded,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
            height: 0.2,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              100000.0.toCurrency(locale: l10n.localeName, symbol: r'$'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            UnconstrainedBox(
              child: IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  minimumSize: AppIconButtonSizes.smallMinimumSize,
                  maximumSize: AppIconButtonSizes.smallMaximumSize,
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.visibility_rounded,
                  size: AppRadius.lg,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionsSlider extends StatelessWidget {
  const _SectionsSlider();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _SectionButton(
            label: 'Overview'.hardCoded,
            isSelected: true,
            onTap: () {
              // Handle overview section tap
            },
          ),
          _SectionButton(
            label: 'Income'.hardCoded,
            isSelected: false,
            onTap: () {
              // Handle income section tap
            },
          ),
          _SectionButton(
            label: 'Expenses'.hardCoded,
            isSelected: false,
            onTap: () {
              // Handle expenses section tap
            },
          ),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : theme.hintColor,
          ),
        ),
      ),
    );
  }
}
