import 'package:app_ui/src/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// {@template extended_color}
/// Extensions for [ExtendedColor] class.
/// {@endtemplate}
extension ExtendedColorExtension on ExtendedColor {
  /// Returns the color for the given [context]
  ColorFamily colorSchemeOf(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.brightness == Brightness.light ? light : dark;
  }
}
