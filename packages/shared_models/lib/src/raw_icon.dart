import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show IconData;

/// Base class for representing different types of icons.
abstract class RawIconData extends Equatable {
  /// Creates a [RawIconData] with a raw string representation.
  const RawIconData({
    required this.raw,
  });

  /// Raw string representation of the icon.
  final String raw;

  @override
  List<Object?> get props => [raw];
}

/// Icon represented by Flutter's [IconData].
class IconDataIcon extends RawIconData {
  /// Creates an [IconDataIcon] with a raw string and [IconData].
  const IconDataIcon({
    required super.raw,
    required this.icon,
  });

  /// The Flutter [IconData] instance.
  final IconData icon;

  @override
  List<Object?> get props => [icon, raw];
}

/// Icon represented by an image URL.
class ImageDataIcon extends RawIconData {
  /// Creates an [ImageDataIcon] with a raw string and URL.
  const ImageDataIcon({
    required super.raw,
    required this.url,
  });

  /// URL pointing to the image resource.
  final String url;

  @override
  List<Object?> get props => [url, raw];
}

/// Icon represented by an emoji character.
class EmojiDataIcon extends RawIconData {
  /// Creates an [EmojiDataIcon] with a raw string and emoji.
  const EmojiDataIcon({
    required super.raw,
    required this.emoji,
  });

  /// The emoji character.
  final String emoji;

  @override
  List<Object?> get props => [emoji, raw];
}
