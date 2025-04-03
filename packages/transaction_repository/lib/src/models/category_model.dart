import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/src/models/transaction_model.dart';

/// {@template category_model}
/// A model representing a transaction category.
///
/// This class represents a category for transactions,
/// which can be organized hierarchically.
/// Each category has properties like name, icon, color, and
/// can be associated with a parent category.
/// {@endtemplate}
class CategoryModel extends Equatable {
  /// Creates a new [CategoryModel] instance.
  ///
  /// {@macro category_model}
  const CategoryModel({
    required this.id,
    required this.transactionType,
    required this.name,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.parentCategoryId,
    this.description,
  });

  /// Unique identifier for the category.
  final String id;

  /// Reference to the parent category's ID.
  /// Can be null for top-level categories.
  final String? parentCategoryId;

  /// Type of transaction this category is associated with.
  final TransactionTypeEnum transactionType;

  /// Name of the category.
  final String name;

  /// Icon identifier for the category.
  final RawIconData icon;

  /// Color code in hex format (e.g., '#FF0000').
  final Color color;

  /// Detailed description of the category.
  final String? description;

  /// Timestamp when the category was created.
  final DateTime createdAt;

  /// Timestamp when the category was last updated.
  final DateTime updatedAt;

  /// Creates a copy of this [CategoryModel] with specified properties updated.
  CategoryModel copyWith({
    String? id,
    String? parentCategoryId,
    TransactionTypeEnum? transactionType,
    String? name,
    RawIconData? icon,
    Color? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      transactionType: transactionType ?? this.transactionType,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns an empty [CategoryModel] instance.
  static CategoryModel empty = CategoryModel(
    id: '',
    transactionType: TransactionTypeEnum.expense,
    name: '',
    icon: const IconDataIcon(raw: '', icon: Icons.forest_outlined),
    color: Colors.black,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// Whether the category is empty (has no ID).
  bool get isEmpty => this == CategoryModel.empty;

  @override
  List<Object?> get props => [
        id,
        parentCategoryId,
        transactionType,
        name,
        icon,
        color,
        description,
        createdAt,
        updatedAt,
      ];
}
