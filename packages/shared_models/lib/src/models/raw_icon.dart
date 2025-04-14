import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for representing different types of icons.
abstract class RawIconData extends Equatable {
  /// Creates a [RawIconData] with a raw string representation.
  const RawIconData({
    required this.raw,
  });

  /// Creates a [RawIconData] from a raw string representation.
  factory RawIconData.fromRaw(String? raw) {
    if (raw == null) {
      return const ErrorDataIcon(
        raw: '',
        icon: Icons.question_mark,
        exception: FormatException('Raw icon is null'),
      );
    }
    final splitParts = raw.split(':');
    if (splitParts.length != 2) {
      return ErrorDataIcon(
        raw: raw,
        icon: Icons.question_mark,
        exception: const FormatException('Invalid raw icon format'),
      );
    }
    final key = splitParts.first;
    final value = splitParts.last;

    return switch (key) {
      'icon' => IconDataIcon(
          raw: raw,
          icon: IconData(int.parse(value), fontFamily: 'MaterialIcons'),
        ),
      'url' => ImageDataIcon(raw: raw, url: value),
      'emoji' => EmojiDataIcon(raw: raw, emoji: value),
      _ => ErrorDataIcon(
          raw: raw,
          icon: Icons.question_mark,
          exception: const FormatException('Invalid raw icon format'),
        )
    };
  }

  /// Converts the icon to a raw string representation.
  String toRaw();

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

  ///  Creates an [IconDataIcon] from a [IconData].
  factory IconDataIcon.fromIconData(IconData icon) {
    return IconDataIcon(
      raw: 'icon:${icon.codePoint}',
      icon: icon,
    );
  }

  /// The Flutter [IconData] instance.
  final IconData icon;

  /// Converts the icon to a raw string representation.
  @override
  String toRaw() => 'icon:${icon.codePoint}';

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

  /// Converts the image URL to a raw string representation.
  @override
  String toRaw() => 'url:$url';

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

  /// Converts the emoji to a raw string representation.
  @override
  String toRaw() => 'emoji:$emoji';

  @override
  List<Object?> get props => [emoji, raw];
}

/// Icon represented by an error.
class ErrorDataIcon extends IconDataIcon {
  /// Creates an [ErrorDataIcon] with a raw string and emoji.
  const ErrorDataIcon({
    required super.raw,
    required super.icon,
    required this.exception,
  });

  /// The error that occurred while parsing the raw icon.
  final Exception exception;

  /// Converts the error to a raw string representation.
  @override
  String toRaw() => 'error:$icon';

  @override
  List<Object?> get props => [icon, exception, raw];
}
