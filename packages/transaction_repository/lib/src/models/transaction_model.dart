import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/src/models/category_model.dart';
import 'package:transaction_repository/src/models/recurrence_model.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// The enum TransactionTypeEnum is used to define the type of transaction.
enum TransactionTypeEnum {
  /// Represents an expense transaction.
  expense,

  /// Represents an income transaction.
  income,

  /// Represents a transfer transaction.
  transfer;

  /// Returns the icon associated with the transaction type.
  IconData get icon {
    switch (this) {
      case TransactionTypeEnum.expense:
        return Icons.arrow_downward;
      case TransactionTypeEnum.income:
        return Icons.arrow_upward;
      case TransactionTypeEnum.transfer:
        return Icons.swap_horiz;
    }
  }
}

/// {@template transaction_model}
/// Represents a financial transaction within a wallet.
/// {@endtemplate}
class TransactionModel extends Equatable {
  /// Creates a new instance of [TransactionModel].
  ///
  /// {@macro transaction_model}
  const TransactionModel({
    required this.id,
    required this.wallet,
    required this.category,
    required this.transactionType,
    required this.amount,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.imageAttachment,
    this.recurrence,
  });

  /// Unique identifier for the transaction.
  final String id;

  /// The wallet associated with this transaction.
  final BaseWalletModel wallet;

  /// The category this transaction belongs to.
  final CategoryModel category;

  /// Type of transaction (e.g., income, expense).
  final TransactionTypeEnum transactionType;

  /// The transaction amount.
  final double amount;

  /// The date and time the transaction occurred.
  final DateTime transactionDate;

  /// Additional notes for the transaction.
  final String? notes;

  /// Optional image attachment for the transaction (e.g., receipt).
  final String? imageAttachment;

  /// Optional recurrence details if the transaction repeats.
  final RecurrenceModel? recurrence;

  /// Timestamp when the transaction was created.
  final DateTime createdAt;

  /// Timestamp when the transaction was last updated.
  final DateTime updatedAt;

  /// Creates a copy of this model with optional new values.
  TransactionModel copyWith({
    String? id,
    BaseWalletModel? wallet,
    CategoryModel? category,
    TransactionTypeEnum? transactionType,
    double? amount,
    DateTime? transactionDate,
    String? notes,
    String? imageAttachment,
    RecurrenceModel? recurrence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      wallet: wallet ?? this.wallet,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      imageAttachment: imageAttachment ?? this.imageAttachment,
      recurrence: recurrence ?? this.recurrence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        wallet,
        category,
        transactionType,
        amount,
        transactionDate,
        notes,
        imageAttachment,
        recurrence,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
