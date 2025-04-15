import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// {@template app_logo}
/// A default app logo.
/// {@endtemplate}
class AppLogo extends StatelessWidget {
  /// {@macro app_logo}
  const AppLogo._({
    required SvgGenImage logo,
    this.size = 48,
    this.color,
    super.key,
  }) : _logo = logo;

  /// The dark app logo.
  AppLogo.dark({
    double? size,
    Color? color,
    Key? key,
  }) : this._(
          size: size,
          color: color,
          logo: Assets.images.logo,
          key: key,
        );

  /// The light app logo.
  AppLogo.light({
    double? size,
    Color? color,
    Key? key,
  }) : this._(
          size: size,
          key: key,
          color: color,
          logo: Assets.images.logo,
        );

  /// The logo to be displayed.
  final SvgGenImage _logo;

  /// The size of the logo.
  final double? size;

  /// The color of the logo.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;
    final effectiveSize = size ?? 48;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        effectiveColor,
        BlendMode.srcIn,
      ),
      child: _logo.svg(
        width: effectiveSize,
        height: effectiveSize,
      ),
    );
  }
}
