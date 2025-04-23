import 'package:app_ui/src/border_radius/app_radius.dart';
import 'package:app_ui/src/colors/app_color_scheme.dart';
import 'package:app_ui/src/sizings/sizings.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// App theme data factory.
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme(this.textTheme);

  /// Current text theme that is used in theme data
  final TextTheme textTheme;

  /// Light theme.
  /// Use [AppTheme.light] to get the light theme.
  ThemeData light() {
    return theme(AppColorScheme.lightScheme());
  }

  /// Dark theme.
  /// Use [AppTheme.dark] to get the dark theme.
  ThemeData dark() {
    return theme(AppColorScheme.darkScheme());
  }

  /// Create a theme from a [ColorScheme].
  ///
  /// This can be use to create a custom theme.
  ThemeData theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        shadowColor: colorScheme.shadow.withValues(alpha: .25),
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        scrolledUnderElevation: 1,
        centerTitle: true,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 1,
        color: colorScheme.primary,
        surfaceTintColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppRadius.xlg),
            ),
          ),
          minimumSize: AppButtonSizes.defaultMinimumSize,
          maximumSize: AppButtonSizes.defaultMaximumSize,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppRadius.lg),
            ),
          ),
          minimumSize: AppButtonSizes.defaultMinimumSize,
          maximumSize: AppButtonSizes.defaultMaximumSize,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg,
          vertical: AppSpacing.lg,
        ),
        fillColor: colorScheme.surfaceContainer,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          isDense: true,
          constraints: BoxConstraints(
            minHeight: AppButtonSizes.smallMinimumSize.height,
            maxHeight: AppButtonSizes.smallMaximumSize.height,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(AppRadius.xlg),
            ),
          ),
        ),
        menuStyle: MenuStyle(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.lg),
              ),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(colorScheme.surface),
          elevation: WidgetStateProperty.all(2),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
      ),
    );
  }
}
