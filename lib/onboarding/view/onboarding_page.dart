import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.xxxlg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_AppLogo(), _AppSlogan()],
                    ),
                  ),
                ),
                _GetStartedButton(),
                Gap(AppSpacing.xlg),
                _AlreadyHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: 96,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppBorderRadius.xxlg),
          ),
          color: theme.colorScheme.primary,
        ),
        child: Assets.images.logo.svg(
          colorFilter: ColorFilter.mode(
            theme.colorScheme.secondaryFixed,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _AppSlogan extends StatelessWidget {
  const _AppSlogan();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'With Felicash'.hardCoded,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(AppSpacing.md),
        Text.rich(
          TextSpan(
            text: 'Take control of your '.hardCoded,
            children: [
              WidgetSpan(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Text(
                    'financial'.hardCoded,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ],
            style: theme.textTheme.titleLarge,
          ),
        ),
        const Gap(AppSpacing.sm),
        Text.rich(
          TextSpan(
            style: theme.textTheme.titleLarge,
            children: [
              TextSpan(
                text: 'Experience the '.hardCoded,
              ),
              WidgetSpan(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Text(
                    'AI'.hardCoded,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: ' assistant'.hardCoded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      child: Text('Get started'.hardCoded),
    );
  }
}

class _AlreadyHaveAccount extends StatelessWidget {
  const _AlreadyHaveAccount();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Already have an account?'.hardCoded,
          style: theme.textTheme.labelLarge,
        ),
        TextButton(
          onPressed: () {
            context.push(AppRoutes.login);
          },
          child: Text('Login now'.hardCoded),
        ),
      ],
    );
  }
}
