import 'package:app_ui/app_ui.dart';
import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/user_setting/bloc/user_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:user_repository/user_repository.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalView();
  }
}

class PersonalView extends StatelessWidget {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.personalPageAppBarTitle),
      ),
      body: Theme(
        data: theme.copyWith(
          listTileTheme: theme.listTileTheme.copyWith(
            shape: const BeveledRectangleBorder(),
            dense: true,
            visualDensity: VisualDensity.compact,
            iconColor: theme.hintColor,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const _UserInfo(),
            const SizedBox(height: AppSpacing.xlg),
            const _ManageSection(),
            const SizedBox(height: AppSpacing.xlg),
            const _General(),
            const SizedBox(height: AppSpacing.xlg),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.personalPageLogoutButtonLabel),
                    leading: const Icon(IconsaxPlusBold.logout_1),
                    onTap: () {
                      context.read<AppBloc>().add(const AppLogOutRequested());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return BlocSelector<AppBloc, AppState, User>(
      selector: (state) {
        return state.user;
      },
      builder: (context, user) {
        return Column(
          children: [
            Text(
              user.email ?? l10n.unknown,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}

class _ManageSection extends StatelessWidget {
  const _ManageSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage'.toUpperCase(),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text('Categories'.hardCoded),
                  leading: const Icon(IconsaxPlusBold.category),
                  onTap: () {
                    // Navigate to categories management
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _General extends StatelessWidget {
  const _General({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General'.toUpperCase(),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text('Language'.hardCoded),
                  leading: const Icon(IconsaxPlusBold.global),
                  onTap: () {},
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('English'.hardCoded),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
                BlocSelector<UserSettingBloc, UserSettingState, ThemeMode>(
                  selector: (state) {
                    return ThemeMode.system;
                  },
                  builder: (context, themeMode) {
                    final themeModeNamed = themeMode.localcalizedName(context);
                    return ListTile(
                      title: Text(themeModeNamed),
                      leading: const Icon(IconsaxPlusBold.sun_1),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('System'.hardCoded),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ],
            ).toList(),
          ),
        ),
      ],
    );
  }
}

extension on ThemeMode {
  String localcalizedName(BuildContext context) {
    // final l10n = context.l10n;
    switch (this) {
      case ThemeMode.system:
        // return l10n.personalPageThemeModeSystem;
        return 'System'.hardCoded;
      case ThemeMode.light:
        // return l10n.personalPageThemeModeLight;
        return 'Light'.hardCoded;
      case ThemeMode.dark:
        // return l10n.personalPageThemeModeDark;
        return 'Dark'.hardCoded;
    }
  }
}
