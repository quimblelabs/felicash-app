import 'package:flutter/material.dart';

/// Wallet type enum
enum WalletTypeEnum {
  /// Basic wallet type
  basic._('basic', 'Basic'),

  /// Credit wallet type
  credit._('credit', 'Credit'),

  /// Savings wallet type
  savings._('savings', 'Savings');

  /// The json key of the enum
  final String jsonKey;

  final String name;

  // ignore: sort_constructors_first
  const WalletTypeEnum._(this.jsonKey, this.name);
}
