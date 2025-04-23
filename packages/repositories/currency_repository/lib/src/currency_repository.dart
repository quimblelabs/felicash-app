import 'dart:developer';

import 'package:currency_repository/src/models/models.dart';
import 'package:currency_repository/src/queries/get_currency_query.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart';

/// {@template currency_failure}
/// Base failure class for currency repository.
/// {@endtemplate}
abstract class CurrencyFailure with EquatableMixin implements Exception {
  /// {@macro currency_failure}
  const CurrencyFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_currencies_failure}
/// Failure when fetching currencies.
/// {@endtemplate}
class GetCurrenciesFailure extends CurrencyFailure {
  /// {@macro get_currencies_failure}
  const GetCurrenciesFailure(super.error);
}

/// {@template get_currency_by_id_failure}
/// Failure when fetching a currency by id.
/// {@endtemplate}
class GetCurrencyByIdFailure extends CurrencyFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByIdFailure(super.error);
}

/// {@template get_currency_by_id_not_found}
///  Failure when fetching a currency by id and it is not found.
/// {@endtemplate}
class GetCurrencyByUserIdNotFound extends GetCurrencyByIdFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByUserIdNotFound([super.error = 'Currency not found']);
}

/// {@template get_currency_by_id_parse_failure}
/// Failure when fetching a currency by id and it is not found.
/// {@endtemplate}
class GetCurrencyByUserIdParseFailure extends GetCurrencyByIdFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByUserIdParseFailure([
    super.error = 'Error parsing currency',
  ]);
}

/// {@template create_currency_failure}
/// Failure when creating a currency.
/// {@endtemplate}
class CreateCurrencyFailure extends CurrencyFailure {
  /// {@macro create_currency_failure}
  const CreateCurrencyFailure(super.error);
}

/// {@template update_currency_failure}
/// Failure when updating a currency.
/// {@endtemplate}
class UpdateCurrencyFailure extends CurrencyFailure {
  /// {@macro update_currency_failure}
  const UpdateCurrencyFailure(super.error);
}

/// {@template currency_repository}
/// Repository for managing currencies.
/// {@endtemplate}
class CurrencyRepository {
  /// {@macro currency_repository}
  const CurrencyRepository({
    required FelicashDataClient client,
  }) : _client = client;

  final FelicashDataClient _client;

  String _query(String query, [List<dynamic>? params]) {
    if (kDebugMode) {
      final loggedQuery = _formatQueryWithParams(query, params);
      log('[CurrencyRepository]: $loggedQuery');
    }
    return query.trim();
  }

  String _formatQueryWithParams(String query, List<dynamic>? params) {
    if (params == null || params.isEmpty) return query;

    var formattedQuery = query;
    var paramIndex = 0;

    // Replace numbered parameters (?1, ?2, etc.)
    final numberedParamRegex = RegExp(r'\?(\d+)');
    formattedQuery = formattedQuery.replaceAllMapped(
      numberedParamRegex,
      (match) {
        final index = int.parse(match.group(1)!) - 1;
        if (index < params.length) {
          return _formatParamValue(params[index]);
        }
        return match.group(0)!;
      },
    );

    // Replace standard parameters (?)
    formattedQuery = formattedQuery.replaceAllMapped(
      RegExp(r'\?(?!\d)'),
      (match) {
        if (paramIndex < params.length) {
          return _formatParamValue(params[paramIndex++]);
        }
        return match.group(0)!;
      },
    );

    return formattedQuery;
  }

  String _formatParamValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is String) return "'$value'";
    if (value is num) return value.toString();
    if (value is bool) return value ? '1' : '0';
    return value.toString();
  }

  // SQL query constants
  static const _getCurrenciesQuery = '''
    SELECT * FROM currencies
    WHERE (?1 IS NULL OR ${CurrencyFields.currencyCode} LIKE ?1)
    AND (?2 IS NULL OR ${CurrencyFields.currencyName} LIKE ?2)
    AND (?3 IS NULL OR ${CurrencyFields.currencySymbol} LIKE ?3)
    ORDER BY 
      CASE WHEN ?4 IS NOT NULL AND ?5 = 'ASC' THEN ?4 END ASC,
      CASE WHEN ?4 IS NOT NULL AND ?5 = 'DESC' THEN ?4 END DESC
    LIMIT ?6 OFFSET ?7
  ''';

  /// Fetches all currencies.
  ///
  /// Throws a [GetCurrenciesFailure] if an error occurs.
  Stream<List<CurrencyModel>> getCurrencies(GetCurrencyQuery query) {
    final params = [
      query.code,
      query.name,
      query.symbol,
      query.orderBy,
      query.orderType.sqlString,
      query.pageSize,
      query.pageIndex,
    ];

    return _client.db
        .watch(
      _query(_getCurrenciesQuery, params),
      parameters: params,
    )
        .map(
      (results) {
        return results.map(
          (row) {
            final currency = Currency.fromRow(row);
            return CurrencyModel.fromCurrency(currency);
          },
        ).toList();
      },
    ).handleError(
      (Object e, StackTrace stacktrace) {
        if (e is GetCurrenciesFailure) throw e;
        Error.throwWithStackTrace(GetCurrenciesFailure(e), stacktrace);
      },
    );
  }
}
