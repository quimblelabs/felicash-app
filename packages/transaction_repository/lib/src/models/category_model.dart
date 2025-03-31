import 'package:equatable/equatable.dart';
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
  final String icon;

  /// Color code in hex format (e.g., '#FF0000').
  final String color;

  /// Detailed description of the category.
  final String? description;

  /// Timestamp when the category was created.
  final DateTime createdAt;

  /// Timestamp when the category was last updated.
  final DateTime updatedAt;

  /// Returns an empty [CategoryModel] instance.
  static CategoryModel empty = CategoryModel(
    id: '',
    transactionType: TransactionTypeEnum.expense,
    name: '',
    icon: '',
    color: '#000000',
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
