import 'package:flutter/material.dart';

/// The enum TransactionTypeEnum is used to define the type of transaction.
enum TransactionTypeEnum {
  /// Represents an expense transaction.
  expense._('expense'),

  /// Represents an income transaction.
  income._('income'),

  /// Represents a transfer transaction.
  transfer._('transfer'),

  /// Represents an unknown transaction type.
  unknown._('unknown');

  /// The json key of the enum
  final String jsonKey;

  // ignore: sort_constructors_first
  const TransactionTypeEnum._(this.jsonKey);

  /// Returns the TransactionTypeEnum value for the given jsonKey.
  static TransactionTypeEnum fromJsonKey(String jsonKey) {
    return TransactionTypeEnum.values.firstWhere(
      (element) => element.jsonKey == jsonKey,
      orElse: () => TransactionTypeEnum.unknown,
    );
  }

  /// Returns the icon associated with the transaction type.
  IconData get icon {
    switch (this) {
      case TransactionTypeEnum.expense:
        return Icons.arrow_downward;
      case TransactionTypeEnum.income:
        return Icons.arrow_upward;
      case TransactionTypeEnum.transfer:
        return Icons.swap_horiz;
      case TransactionTypeEnum.unknown:
        return Icons.question_mark;
    }
  }
}
