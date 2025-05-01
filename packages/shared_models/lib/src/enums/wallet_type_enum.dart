import 'package:json_annotation/json_annotation.dart';

/// Wallet type enum
enum WalletTypeEnum {
  /// Basic wallet type
  @JsonValue('basic')
  basic._('basic'),

  /// Credit wallet type
  @JsonValue('credit')
  credit._('credit'),

  /// Savings wallet type
  @JsonValue('savings')
  savings._('savings');

  /// The json key of the enum
  final String jsonKey;

  // ignore: sort_constructors_first
  const WalletTypeEnum._(this.jsonKey);
}
