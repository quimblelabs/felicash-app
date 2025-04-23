import 'package:json_annotation/json_annotation.dart';

/// Wallet type enum
enum WalletTypeEnum {
  /// Basic wallet type
  @JsonValue('basic')
  basic._('basic', 'Basic'),

  /// Credit wallet type
  @JsonValue('credit')
  credit._('credit', 'Credit'),

  /// Savings wallet type
  @JsonValue('savings')
  savings._('savings', 'Savings');

  /// The json key of the enum
  final String jsonKey;

  /// The name of the enum
  final String name;

  // ignore: sort_constructors_first
  const WalletTypeEnum._(this.jsonKey, this.name);
}
