import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

/// {@template category_fields}
/// Category fields
/// {@endtemplate}

typedef CategoryFields = _$CategoryJsonKeys;

/// {@template credit_wallet_model}
/// Category model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Category {
  /// {@macro category_model}
  const Category({
    required this.categoryId,
    required this.categoryUserId,
    required this.categoryTransactionType,
    required this.categoryName,
    required this.categoryEnabled,
    required this.categoryCreatedAt,
    required this.categoryUpdatedAt,
    this.categoryParentCategoryId,
    this.categoryIcon,
    this.categoryColor,
    this.categoryDescription,
  }) : id = categoryId;

  /// Factory constructor [Category] from [SqliteRow]
  factory Category.fromRow(SqliteRow row) {
    return Category(
      categoryId: row[CategoryFields.categoryId] as String,
      categoryUserId: row[CategoryFields.categoryUserId] as String,
      categoryTransactionType: TransactionType.values.byName(
        row[CategoryFields.categoryTransactionType] as String,
      ),
      categoryName: row[CategoryFields.categoryName] as String,
      categoryEnabled: row[CategoryFields.categoryEnabled] == 1,
      categoryCreatedAt: DateTime.parse(
        row[CategoryFields.categoryCreatedAt] as String,
      ),
      categoryUpdatedAt: DateTime.parse(
        row[CategoryFields.categoryUpdatedAt] as String,
      ),
      categoryParentCategoryId:
          row[CategoryFields.categoryParentCategoryId] as String?,
      categoryIcon: row[CategoryFields.categoryIcon] as String?,
      categoryColor: row[CategoryFields.categoryColor] as String?,
      categoryDescription: row[CategoryFields.categoryDescription] as String?,
    );
  }

  /// Table name of the category
  static const String tableName = 'categories';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the category
  final String categoryId;

  /// Profile of the category
  final String categoryUserId;

  /// Parent category of the category
  final String? categoryParentCategoryId;

  /// Transaction type of the category
  final TransactionType categoryTransactionType;

  /// Name of the category of the category
  final String categoryName;

  /// Icon of the category
  /// Reason for archiving the wallet
  final String? categoryIcon;

  /// Color of the category
  /// Reason for archiving the wallet
  final String? categoryColor;

  /// Description of the category
  /// Reason for archiving the wallet
  final String? categoryDescription;

  /// Enabled of the category
  final bool categoryEnabled;

  /// Created at of the category
  final DateTime categoryCreatedAt;

  /// Updated at of the category
  final DateTime categoryUpdatedAt;

  /// Returns a copy of the [Category] with the given fields replaced.
  Category copyWith({
    String? categoryId,
    String? categoryUserId,
    String? categoryParentCategoryId,
    TransactionType? categoryTransactionType,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    String? categoryDescription,
    bool? categoryEnabled,
    DateTime? categoryCreatedAt,
    DateTime? categoryUpdatedAt,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      categoryUserId: categoryUserId ?? this.categoryUserId,
      categoryParentCategoryId:
          categoryParentCategoryId ?? this.categoryParentCategoryId,
      categoryTransactionType:
          categoryTransactionType ?? this.categoryTransactionType,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      categoryEnabled: categoryEnabled ?? this.categoryEnabled,
      categoryCreatedAt: categoryCreatedAt ?? this.categoryCreatedAt,
      categoryUpdatedAt: categoryUpdatedAt ?? this.categoryUpdatedAt,
    );
  }
}
