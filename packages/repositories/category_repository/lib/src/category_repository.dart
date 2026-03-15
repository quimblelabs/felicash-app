import 'dart:developer';

import 'package:category_repository/src/queries/get_category_query.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:shared_models/shared_models.dart';

import 'models/category_model.dart';

/// {@template category_failure}
/// Base failure class for category repository.
/// {@endtemplate}
abstract class CategoryFailure with EquatableMixin implements Exception {
  /// {@macro category_failure}
  const CategoryFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_categories_failure}
/// Failure when fetching categories.
/// {@endtemplate}
class GetCategoriesFailure extends CategoryFailure {
  /// {@macro get_categories_failure}
  const GetCategoriesFailure(super.error);
}

/// {@template get_category_by_id_failure}
/// Failure when fetching a category by id.
/// {@endtemplate}
class GetCategoryByIdFailure extends CategoryFailure {
  /// {@macro get_category_by_id_failure}
  const GetCategoryByIdFailure(super.error);
}

/// {@template create_category_failure}
/// Failure when creating a category.
/// {@endtemplate}
class CreateCategoryFailure extends CategoryFailure {
  /// {@macro create_category_failure}
  const CreateCategoryFailure(super.error);
}

/// {@template update_category_failure}
/// Failure when updating a category.
/// {@endtemplate}
class UpdateCategoryFailure extends CategoryFailure {
  /// {@macro update_category_failure}
  const UpdateCategoryFailure(super.error);
}

/// {@template delete_category_failure}
/// Failure when deleting a category.
/// {@endtemplate}
class DeleteCategoryFailure extends CategoryFailure {
  /// {@macro delete_category_failure}
  const DeleteCategoryFailure(super.error);
}

class CategoryRepository {
  /// {@macro wallet_repository}
  CategoryRepository({required FelicashDataClient client}) : _client = client;

  final FelicashDataClient _client;

  static const _getCategoriesQuery = '''
    SELECT * 
    FROM categories c
    WHERE c.${CategoryFields.categoryUserId} = ?1
          AND (?2 IS NULL OR c.${CategoryFields.categoryParentCategoryId} = ?2)
          AND (?3 IS NULL OR c.${CategoryFields.categoryTransactionType} = ?3)
          AND (?4 IS NULL OR c.${CategoryFields.categoryName} = ?4)
          AND (?5 IS NULL OR c.${CategoryFields.categoryDescription} = ?5)
          AND (?6 IS NULL OR c.${CategoryFields.categoryEnabled} = ?6)
    ORDER BY 
      CASE WHEN ?7 IS NOT NULL AND ?8 = 'ASC' THEN ?7 END ASC,
      CASE WHEN ?7 IS NOT NULL AND ?8 = 'DESC' THEN ?7 END DESC
    LIMIT ?9 OFFSET ?10
  ''';

  Stream<List<CategoryModel>> getCategoriesStream(GetCategoryQuery query) {
    final params = [
      _client.getUserId(),
      query.parentCategoryId,
      query.transactionType,
      query.name,
      query.description,

      query.enabled,
      query.orderBy,
      query.orderType.sqlString,
      query.limit,
      query.offset,
    ];
    return _client.db
        .watch(_query(_getCategoriesQuery, params), parameters: params)
        .map((results) {
          if (results.isEmpty) return <CategoryModel>[];

          final categoriesMap = <String, Category>{};

          for (final row in results) {
            final category = Category.fromRow(row);
            categoriesMap[category.categoryId] = category;
          }

          final categories = categoriesMap.values.toList();
          final categoryModels = <CategoryModel>[];

          for (final category in categories) {
            final categoryModel = CategoryModel.fromCategory(category);
            categoryModels.add(categoryModel);
          }

          return categoryModels;
        })
        .handleError((Object e, StackTrace stacktrace) {
          if (e is GetCategoriesFailure) throw e;
          Error.throwWithStackTrace(GetCategoriesFailure(e), stacktrace);
        });
  }

  Future<List<CategoryModel>> getCategoriesFuture(
    GetCategoryQuery query,
  ) async {
    final params = [
      _client.getUserId(),
      query.parentCategoryId,
      query.transactionType,
      query.name,
      query.description,

      query.enabled,
      query.orderBy,
      query.orderType.sqlString,
      query.limit,
      query.offset,
    ];

    try {
      final results = await _client.db.getAll(
        _query(_getCategoriesQuery, params),
        params,
      );

      if (results.isEmpty) return <CategoryModel>[];

      final categoriesMap = <String, Category>{};

      for (final row in results) {
        final category = Category.fromRow(row);
        categoriesMap[category.categoryId] = category;
      }

      final categories = categoriesMap.values.toList();
      final categoryModels = <CategoryModel>[];

      for (final category in categories) {
        final categoryModel = CategoryModel.fromCategory(category);
        categoryModels.add(categoryModel);
      }

      return categoryModels;
    } catch (e, stacktrace) {
      if (e is GetCategoriesFailure) rethrow;
      Error.throwWithStackTrace(GetCategoriesFailure(e), stacktrace);
    }
  }

  static const _getCategoryByIdQuery = '''
      SELECT *
      FROM categories c
      WHERE c.${CategoryFields.categoryId} =?1
    ''';

  Stream<CategoryModel> getCategoryById(String id) {
    final params = [id];
    return _client.db
        .watch(_query(_getCategoryByIdQuery, params), parameters: params)
        .map((results) {
          if (results.isEmpty) {
            throw GetCategoryByIdFailure('Category not found');
          }
          final row = results.first;
          final category = Category.fromRow(row);
          final categoryModel = CategoryModel.fromCategory(category);
          return categoryModel;
        })
        .handleError((Object e, StackTrace stacktrace) {
          if (e is GetCategoryByIdFailure) throw e;
          Error.throwWithStackTrace(GetCategoryByIdFailure(e), stacktrace);
        });
  }

  static const _createCategoryQuery = '''
    INSERT INTO categories (
      ${CategoryFields.id},
      ${CategoryFields.categoryId},
      ${CategoryFields.categoryUserId},
      ${CategoryFields.categoryParentCategoryId},
      ${CategoryFields.categoryTransactionType},
      ${CategoryFields.categoryName},
      ${CategoryFields.categoryIcon},
      ${CategoryFields.categoryColor},
      ${CategoryFields.categoryDescription},
      ${CategoryFields.categoryCreatedAt},
      ${CategoryFields.categoryUpdatedAt},
      ${CategoryFields.categoryEnabled}
    ) VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9,datetime(),datetime(),1)
  ''';

  Future<void> createCategory(CategoryModel category) async {
    try {
      await _client.db.writeTransaction((tx) async {
        final params = [
          category.id,
          category.id,
          _client.getUserId(),
          category.parentCategoryId,
          category.transactionType.jsonKey,
          category.name,
          category.icon.toRaw(),
          category.color.toHex(),
          category.description,
        ];
        await tx.execute(_query(_createCategoryQuery, params), params);
      });
    } on CreateCategoryFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(CreateCategoryFailure(e), stacktrace);
    }
  }

  static const _updateCategoryQuery = '''
    UPDATE categories
    SET
      CASE 
        WHEN ?1 IS NOT NULL THEN ${CategoryFields.categoryParentCategoryId} =?1
        WHEN ?2 IS NOT NULL THEN ${CategoryFields.categoryName} =?2
        WHEN ?3 IS NOT NULL THEN ${CategoryFields.categoryTransactionType} =?3
        WHEN ?5 IS NOT NULL THEN ${CategoryFields.categoryDescription} =?4
        WHEN ?6 IS NOT NULL THEN ${CategoryFields.categoryIcon} =?5
        WHEN ?7 IS NOT NULL THEN ${CategoryFields.categoryColor} =?6
        WHEN ?8 IS NOT NULL THEN ${CategoryFields.categoryEnabled} =?7
      END,
      ${CategoryFields.categoryUpdatedAt} =?8
    WHERE ${CategoryFields.categoryId} =?9
    RETURNING *
  ''';

  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      final updatedCategory = await _client.db.writeTransaction<Category>((
        tx,
      ) async {
        final params = [
          category.parentCategoryId,
          category.name,
          category.transactionType,
          category.description,
          category.icon,
          //
          category.color,
          category.enabled,
          DateTime.now().toIso8601String(),
          category.id,
        ];
        final rows = await tx.execute(
          _query(_updateCategoryQuery, params),
          params,
        );
        if (rows.isEmpty) {
          throw UpdateCategoryFailure('Failed to update category');
        }
        final row = rows.first;
        return Category.fromRow(row);
      });
      final categoryModel = CategoryModel.fromCategory(updatedCategory);
      return categoryModel;
    } on UpdateCategoryFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(UpdateCategoryFailure(e), stacktrace);
    }
  }

  static const _deleteCategoryQuery = '''
    DELETE FROM categories
    WHERE ${CategoryFields.categoryId} =?1
  ''';

  Future<void> deleteCategory(String id) async {
    try {
      await _client.db.writeTransaction((tx) async {
        final params = [id];
        await tx.execute(_query(_deleteCategoryQuery, params), params);
      });
    } on DeleteCategoryFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(DeleteCategoryFailure(e), stacktrace);
    }
  }

  String _query(String query, [List<dynamic>? params]) {
    if (foundation.kDebugMode) {
      final loggedQuery = _formatQueryWithParams(query, params);
      log('[CategoryRepository]: $loggedQuery');
    }
    return query.trim();
  }

  String _formatQueryWithParams(String query, List<dynamic>? params) {
    if (params == null || params.isEmpty) return query;

    var formattedQuery = query;
    var paramIndex = 0;

    // Replace numbered parameters (?1, ?2, etc.)
    final numberedParamRegex = RegExp(r'\?(\d+)');
    formattedQuery = formattedQuery.replaceAllMapped(numberedParamRegex, (
      match,
    ) {
      final index = int.parse(match.group(1)!) - 1;
      if (index < params.length) {
        return _formatParamValue(params[index]);
      }
      return match.group(0)!;
    });

    // Replace standard parameters (?)
    formattedQuery = formattedQuery.replaceAllMapped(RegExp(r'\?(?!\d)'), (
      match,
    ) {
      if (paramIndex < params.length) {
        return _formatParamValue(params[paramIndex++]);
      }
      return match.group(0)!;
    });

    return formattedQuery;
  }

  String _formatParamValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is String) return "'$value'";
    if (value is num) return value.toString();
    if (value is bool) return value ? '1' : '0';
    return value.toString();
  }
}
