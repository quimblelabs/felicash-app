import 'dart:ui';

/// An extension on the [Color] class.
extension ColorExtension on Color {
  /// Returns the color that should be used on top of this color.
  Color get onContainer {
    final brightness = computeLuminance();
    if (brightness > 0.5) {
      return const Color(0xFF000000);
    } else {
      return const Color(0xFFFFFFFF);
    }
  }
}
