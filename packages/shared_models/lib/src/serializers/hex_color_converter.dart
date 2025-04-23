import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/src/extensions/color_extension.dart';

/// {@template hex_color_converter}
/// A converter for [Color] to and from [String]
/// {@endtemplate}
class HexColorConverter extends JsonConverter<Color, String> {
  /// {@macro hex_color_converter}
  const HexColorConverter();

  @override
  Color fromJson(String json) => HexColor.fromHex(json);

  @override
  String toJson(Color object) => object.toHex();
}
