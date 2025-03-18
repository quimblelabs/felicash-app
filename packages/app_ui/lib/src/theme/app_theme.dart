import 'package:app_ui/src/colors/app_color_scheme.dart';
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
    );
  }

  /// Extend the theme with a custom [ColorScheme].
  List<ExtendedColor> get extendedColors => [];
}

/// {@template extended_color}
/// The data of the extended color.
/// {@endtemplate}
class ExtendedColor {
  /// {@macro extended_color}
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });

  /// The seed color of the extended color.
  final Color seed;

  /// The value of the extended color.
  final Color value;

  /// The light color blend of the extended color.
  final ColorFamily light;

  /// The light color blend of the extended color with high contrast.
  final ColorFamily lightHighContrast;

  /// The light color blend of the extended color with medium contrast.
  final ColorFamily lightMediumContrast;

  /// The dark color blend of the extended color.
  final ColorFamily dark;

  /// The dark color blend of the extended color with high contrast.
  final ColorFamily darkHighContrast;

  /// The dark color blend of the extended color with medium contrast.
  final ColorFamily darkMediumContrast;
}

/// {@template color_family}
/// The data of the color family. The color family is the color and its
/// variants.
/// {@endtemplate}
class ColorFamily {
  /// {@macro color_family}
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  /// The color of the color family.
  final Color color;

  /// The on color of the color family.
  final Color onColor;

  /// The color container of the color family.
  final Color colorContainer;

  /// The on color container of the color family.
  final Color onColorContainer;
}
