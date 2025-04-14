import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:shared_models/shared_models.dart';

class GetCategoryQuery extends BaseGetQuery {
  const GetCategoryQuery({
    required this.parentCategoryId,
    this.transactionType,
    this.name,
    this.description,
    this.enabled = true,
    super.pageIndex,
    super.pageSize,
    super.orderType,
    super.orderBy = CategoryFields.categoryCreatedAt,
  });

  /// The parent category id to get the subcategories for.
  final String? parentCategoryId;

  /// The transaction type to get the category for.
  final TransactionTypeEnum? transactionType;

  /// The category name to get the category for.
  final String? name;

  /// The category description to get the category for.
  final String? description;

  /// The category type to get the category for.
  final bool enabled;

  @override
  List<Object?> get props => [
    pageIndex,
    pageSize,
    parentCategoryId,
    transactionType,
    name,
    description,
    enabled,
  ];
}
