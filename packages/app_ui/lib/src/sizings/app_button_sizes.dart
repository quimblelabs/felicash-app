import 'dart:ui';

/// The sizes of the buttons in the app.
abstract class AppButtonSizes {
  /// The maximum size of the small variant of the button.
  static const smallMaximumSize = Size(double.infinity, 40);

  /// The minimum size of the small variant of the button.
  static const smallMinimumSize = Size(0, 40);

  /// The minimum size of a button.
  static const defaultMinimumSize = Size(double.infinity, 56);

  /// The maximum size of a button.
  static const defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the large variant of the button.
  static const largeMinimumSize = Size(double.infinity, 64);

  /// The maximum size of the large variant of the button.
  static const largeMaximumSize = Size(double.infinity, 64);
}
