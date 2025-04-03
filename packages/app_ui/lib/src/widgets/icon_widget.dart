import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

/// {@template icon_widget}
/// A widget that displays an icon for a given [RawIconData].
/// {@endtemplate}
class IconWidget extends StatelessWidget {
  /// {@macro icon_widget}
  const IconWidget({
    required this.icon,
    this.size,
    this.color,
    super.key,
  });

  /// The icon to display.
  final RawIconData icon;

  /// The size of the icon.
  ///
  /// Defaults to 24.
  final double? size;

  /// The color of the icon.
  ///
  /// Defaults to the theme's hint color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    final effectiveColor = color ?? iconTheme.color ?? theme.hintColor;
    final effectiveSize = size ?? iconTheme.size ?? 24;
    if (icon case final IconDataIcon iconDataIcon) {
      return Icon(
        iconDataIcon.icon,
        size: effectiveSize,
        color: effectiveColor,
      );
    } else if (icon case final ImageDataIcon imageIconDataIcon) {
      return ImageIcon(
        NetworkImage(imageIconDataIcon.url),
        size: effectiveSize,
        color: effectiveColor,
      );
    } else if (icon case final EmojiDataIcon emojiIconDataIcon) {
      return Text(
        emojiIconDataIcon.emoji,
        style: TextStyle(
          fontSize: effectiveSize,
          color: effectiveColor,
        ),
      );
    } else {
      return ErrorWidget(
        'The icon type ${icon.runtimeType} is not supported for IconWidget.',
      );
    }
  }
}
