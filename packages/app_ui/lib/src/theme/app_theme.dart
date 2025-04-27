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
      dividerTheme: _dividerTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      bottomAppBarTheme: _bottomAppBarTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dropdownMenuTheme: _dropdownMenuTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
    );
  }

  AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      shadowColor: colorScheme.shadow.withValues(alpha: .25),
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      scrolledUnderElevation: 1,
      centerTitle: true,
    );
  }

  CardTheme _cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      elevation: 1,
    );
  }

  ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
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
    );
  }

  BottomAppBarTheme _bottomAppBarTheme(ColorScheme colorScheme) {
    return BottomAppBarTheme(
      elevation: 1,
      color: colorScheme.primary,
      surfaceTintColor: colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    );
  }

  DividerThemeData _dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant.withAlpha(100),
    );
  }

  FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        minimumSize: AppButtonSizes.defaultMinimumSize,
        maximumSize: AppButtonSizes.defaultMaximumSize,
      ),
    );
  }

  OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        minimumSize: AppButtonSizes.defaultMinimumSize,
        maximumSize: AppButtonSizes.defaultMaximumSize,
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
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
    );
  }

  DropdownMenuThemeData _dropdownMenuTheme(ColorScheme colorScheme) {
    return DropdownMenuThemeData(
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
    );
  }

  ChipThemeData _chipTheme(ColorScheme colorScheme) {
    return const ChipThemeData(
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
