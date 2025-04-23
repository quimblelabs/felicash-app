import 'package:json_annotation/json_annotation.dart';
import 'package:shared_models/src/models/raw_icon.dart';

/// {@template raw_icon_data_converter}
/// A converter for [RawIconData] to and from [String]
/// {@endtemplate}
class RawIconDataConverter extends JsonConverter<RawIconData, String> {
  /// {@macro raw_icon_data_converter}
  const RawIconDataConverter();

  @override
  RawIconData fromJson(String json) => RawIconData.fromRaw(json);

  @override
  String toJson(RawIconData object) => object.toRaw();
}
