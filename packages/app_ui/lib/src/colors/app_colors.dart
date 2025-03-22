import 'dart:ui';

/// {@template app_colors}
/// Contains the app colors.
/// {@endtemplate}
abstract class AppColors {
  /// Tangerine
  static const tangerine = ExtendedColor(
    seed: Color(0xffe67e22),
    value: Color(0xffe67e22),
    light: ColorFamily(
      color: Color(0xff944a00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfff4892d),
      onColorContainer: Color(0xff2d1200),
    ),
    dark: ColorFamily(
      color: Color(0xffffb783),
      onColor: Color(0xff4f2500),
      colorContainer: Color(0xffdd771a),
      onColorContainer: Color(0xff000000),
    ),
  );

  /// Dollar Bill
  static const dollarBill = ExtendedColor(
    seed: Color(0xff85bb65),
    value: Color(0xff85bb65),
    light: ColorFamily(
      color: Color(0xff396a1e),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff8fc66e),
      onColorContainer: Color(0xff103200),
    ),
    dark: ColorFamily(
      color: Color(0xffa5dd83),
      onColor: Color(0xff133800),
      colorContainer: Color(0xff7eb35e),
      onColorContainer: Color(0xff081f00),
    ),
  );

  /// Havest Gold
  static const havestGold = ExtendedColor(
    seed: Color(0xfff3ab11),
    value: Color(0xfff3ab11),
    light: ColorFamily(
      color: Color(0xff7f5700),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfffdb31e),
      onColorContainer: Color(0xff452e00),
    ),
    dark: ColorFamily(
      color: Color(0xffffd698),
      onColor: Color(0xff432c00),
      colorContainer: Color(0xffeca504),
      onColorContainer: Color(0xff372400),
    ),
  );

  /// Gold
  static const gold = ExtendedColor(
    seed: Color(0xffffd700),
    value: Color(0xffffd700),
    light: ColorFamily(
      color: Color(0xff705d00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdd50),
      onColorContainer: Color(0xff534500),
    ),
    dark: ColorFamily(
      color: Color(0xffffffff),
      onColor: Color(0xff3a3000),
      colorContainer: Color(0xfff9d200),
      onColorContainer: Color(0xff4c3e00),
    ),
  );

  /// Crimsion Red
  static const crimsionRed = ExtendedColor(
    seed: Color(0xffdc143c),
    value: Color(0xffdc143c),
    light: ColorFamily(
      color: Color(0xff9b0025),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffdc143c),
      onColorContainer: Color(0xffffffff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb3b3),
      onColor: Color(0xff680015),
      colorContainer: Color(0xffcf0035),
      onColorContainer: Color(0xffffffff),
    ),
  );
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
    required this.dark,
  });

  /// The seed color of the extended color.
  final Color seed;

  /// The value of the extended color.
  final Color value;

  /// The light color blend of the extended color.
  final ColorFamily light;

  /// The dark color blend of the extended color.
  final ColorFamily dark;
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
