import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/src/models/transaction_model.dart';
import 'package:transaction_repository/src/models/transaction_summary_by_category_model.dart';
import 'package:transaction_repository/src/queries/get_transaction_query.dart';
import 'package:transaction_repository/src/queries/get_transaction_summary_by_category_query.dart';
import 'package:uuid/uuid.dart';

/// {@template transaction_failure}
/// Base failure class for transaction repository.
/// {@endtemplate}
abstract class TransactionFailure with EquatableMixin implements Exception {
  /// {@macro transaction_failure}
  const TransactionFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_transactions_failure}
/// Failure when fetching transactions.
/// {@endtemplate}
class GetTransactionsFailure extends TransactionFailure {
  /// {@macro get_transactions_failure}
  const GetTransactionsFailure(super.error);
}

/// {@template get_transaction_by_id_failure}
/// Failure when fetching a transaction by id.
/// {@endtemplate}
class GetTransactionByIdFailure extends TransactionFailure {
  /// {@macro get_transaction_by_id_failure}
  const GetTransactionByIdFailure(super.error);
}

/// {@template create_transaction_failure}
/// Failure when creating a transaction.
/// {@endtemplate}
class CreateTransactionFailure extends TransactionFailure {
  /// {@macro create_transaction_failure}
  const CreateTransactionFailure(super.error);
}

/// {@template update_transaction_failure}
/// Failure when updating a transaction.
/// {@endtemplate}
class UpdateTransactionFailure extends TransactionFailure {
  /// {@macro update_transaction_failure}
  const UpdateTransactionFailure(super.error);
}

/// {@template delete_transaction_failure}
/// Failure when deleting a transaction.
/// {@endtemplate}
class DeleteTransactionFailure extends TransactionFailure {
  /// {@macro delete_transaction_failure}
  const DeleteTransactionFailure(super.error);
}

/// {@template transaction_repository}
/// A transaction repository.
/// {@endtemplate}
class TransactionRepository {
  /// {@macro transaction_repository}
  TransactionRepository({
    required FelicashDataClient client,
  }) : _client = client;

  final FelicashDataClient _client;

  String _query(String query, [List<dynamic>? params]) {
    if (kDebugMode) {
      final loggedQuery = _formatQueryWithParams(query, params);
      log('[TransactionRepository]: $loggedQuery');
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

  static const _getTransactionsQuery = '''
    SELECT *
    FROM transactions t
    WHERE t.${TransactionFields.transactionUserId} = ?1
    AND (?2 IS NULL OR t.${TransactionFields.transactionWalletId} = ?2)
    AND (?3 IS NULL OR t.${TransactionFields.transactionCategoryId} = ?3)
    AND (?4 IS NULL OR t.${TransactionFields.transactionTransactionType} = ?4)
    AND (?5 IS NULL OR t.${TransactionFields.transactionTransactionDate} >= ?5)
    AND (?6 IS NULL OR t.${TransactionFields.transactionTransactionDate} <= ?6)
    AND (?7 IS NULL OR t.${TransactionFields.transactionAmount} >= ?7)
    AND (?8 IS NULL OR t.${TransactionFields.transactionAmount} <= ?8)
    AND (?9 IS NULL OR t.${TransactionFields.transactionNotes} LIKE '%' || ?9 || '%')
    ORDER BY t.${TransactionFields.transactionCreatedAt} DESC
    LIMIT ?10 OFFSET ?11
  ''';

  /// Get transactions.
  Stream<List<TransactionModel>> getTransactions(GetTransactionQuery query) {
    final params = [
      _client.getUserId(),
      query.walletId,
      query.categoryId,
      query.transactionType?.jsonKey,
      query.startDate?.toUtc().toIso8601String(),
      query.endDate?.toUtc().toIso8601String(),
      query.minAmount,
      query.maxAmount,
      query.transactionNotes,
      query.limit,
      query.offset,
    ];

    return _client.db
        .watch(
      _query(_getTransactionsQuery, params),
      parameters: params,
    )
        .map(
      (results) {
        return results
            .map(Transaction.fromRow)
            .map(TransactionModel.fromTransaction)
            .toList();
      },
    ).handleError(
      (Object e, StackTrace stacktrace) {
        Error.throwWithStackTrace(GetTransactionsFailure(e), stacktrace);
      },
    );
  }

  static const _getTransactionByIdQuery = '''
    SELECT *
    FROM transactions t
    WHERE t.${TransactionFields.transactionId} = ?1
  ''';

  /// Get a transaction by id.
  Future<TransactionModel> getTransactionByIdFuture(String id) async {
    try {
      final params = [id];
      final row = await _client.db.get(
        _query(_getTransactionByIdQuery, params),
        params,
      );
      final transaction = Transaction.fromRow(row);
      return TransactionModel.fromTransaction(transaction);
    } on GetTransactionByIdFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(GetTransactionByIdFailure(e), stacktrace);
    }
  }

  /// Get a transaction by id.
  Stream<TransactionModel> getTransactionByIdStream(String id) {
    final params = [id];
    return _client.db
        .watch(
      _query(_getTransactionByIdQuery, params),
      parameters: params,
    )
        .map((results) {
      if (results.isEmpty) {
        throw const GetTransactionByIdFailure('Transaction not found');
      }
      final row = results.first;
      final transaction = Transaction.fromRow(row);
      return TransactionModel.fromTransaction(transaction);
    }).handleError(
      (Object e, StackTrace stacktrace) {
        if (e is GetTransactionByIdFailure) throw e;
        Error.throwWithStackTrace(GetTransactionByIdFailure(e), stacktrace);
      },
    );
  }

  static const _updateWalletBalanceQueryAfterTransactionCreated = '''
    UPDATE wallets
    SET ${WalletFields.walletBalance} = ${WalletFields.walletBalance} + ?1,
        ${WalletFields.walletUpdatedAt} = datetime()
    WHERE ${WalletFields.walletId} = ?2
    RETURNING *
  ''';

  static const _updateTransactionTransferTransactionQuery = '''
    UPDATE transactions
    SET ${TransactionFields.transactionTransferId} = ?1
    WHERE ${TransactionFields.transactionId} = ?2
    RETURNING *
  ''';

  static const _createTransactionQuery = '''
    INSERT INTO transactions (
      ${TransactionFields.id},
      ${TransactionFields.transactionId},
      ${TransactionFields.transactionUserId},
      ${TransactionFields.transactionWalletId},
      ${TransactionFields.transactionCategoryId},

      ${TransactionFields.transactionTransactionType},
      ${TransactionFields.transactionAmount},
      ${TransactionFields.transactionTransactionDate},
      ${TransactionFields.transactionNotes},
      ${TransactionFields.transactionImageAttachment},

      ${TransactionFields.transactionRecurrenceId},
      ${TransactionFields.transactionTransferId},
      ${TransactionFields.transactionCreatedAt},
      ${TransactionFields.transactionUpdatedAt},
      ${TransactionFields.transactionMerchantId},
    )
    VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, datetime(), datetime(), ?13)
    RETURNING *
  ''';

  /// Create a transaction.
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      // Validate with transaction type
      switch (transaction.transactionType) {
        case TransactionTypeEnum.income:
          if (transaction.amount <= 0) {
            throw const CreateTransactionFailure(
              'Income amount must be positive',
            );
          }
        case TransactionTypeEnum.expense:
          if (transaction.amount >= 0) {
            throw const CreateTransactionFailure(
              'Expense amount must be negative',
            );
          }
        case TransactionTypeEnum.transfer:
          if (transaction.amount >= 0) {
            throw const CreateTransactionFailure(
              'Transfer amount must be negative',
            );
          }
          if (transaction.transferWallet == null) {
            throw const CreateTransactionFailure(
              'Transfer wallet is required for transfer transactions',
            );
          }
        case TransactionTypeEnum.unknown:
          throw const CreateTransactionFailure(
            'Unknown transaction type',
          );
      }
      final createdTransaction = await _client.db.writeTransaction(
        (tx) async {
          // Create transaction
          final transactionParams = [
            transaction.id,
            transaction.id,
            _client.getUserId(),
            transaction.wallet.id,
            transaction.category?.id,
            //
            transaction.transactionType.jsonKey,
            transaction.amount,
            transaction.transactionDate,
            transaction.notes,
            transaction.imageAttachment,
            //
            transaction.recurrence?.id,
            null,
            transaction.merchantId,
          ];

          final transactionRows = await tx.execute(
            _query(_createTransactionQuery, transactionParams),
            transactionParams,
          );

          if (transactionRows.isEmpty) {
            throw CreateTransactionFailure(
              'Failed to create transaction: ${transaction.notes}',
            );
          }

          // Update source wallet balance
          final params = [transaction.amount, transaction.wallet.id];

          final rows = await tx.execute(
            _query(_updateWalletBalanceQueryAfterTransactionCreated, params),
            params,
          );

          if (rows.isEmpty) {
            throw const UpdateTransactionFailure(
              'Failed to update wallet balance',
            );
          }

          var transactionCreated = Transaction.fromRow(
            transactionRows.first,
          );

          if (transaction.transactionType == TransactionTypeEnum.transfer) {
            // Create destination transaction
            final destinationTransactionId = const Uuid().v4();
            final transactionDestinationParams = [
              destinationTransactionId,
              destinationTransactionId,
              _client.getUserId(),
              transaction.transferWallet!.id,
              transaction.category?.id,
              //
              transaction.transactionType.jsonKey,
              -transaction.amount,
              transaction.transactionDate,
              transaction.notes,
              transaction.imageAttachment,
              //
              transaction.recurrence?.id,
              transactionCreated.transactionId,
              transaction.merchantId,
            ];

            final transactionDestinationRows = await tx.execute(
              _query(_createTransactionQuery, transactionDestinationParams),
              transactionDestinationParams,
            );

            if (transactionDestinationRows.isEmpty) {
              throw const CreateTransactionFailure(
                'Failed to create transaction destination',
              );
            }

            final transactionDestination =
                Transaction.fromRow(transactionDestinationRows.first);

            // Update source transaction transfer transaction
            final sourceTransactionParams = [
              transactionDestination.id,
              transactionCreated.id,
            ];

            await tx.execute(
              _query(
                _updateTransactionTransferTransactionQuery,
                sourceTransactionParams,
              ),
              sourceTransactionParams,
            );

            transactionCreated = transactionCreated.copyWith(
              transactionTransferId: transactionDestination.id,
              transactions: [
                transactionDestination,
              ],
            );

            // Update destination wallet balance
            final params = [
              -transaction.amount,
              transaction.transferWallet!.id,
            ];

            final rows = await tx.execute(
              _query(_updateWalletBalanceQueryAfterTransactionCreated, params),
              params,
            );

            if (rows.isEmpty) {
              throw const CreateTransactionFailure(
                'Failed to update wallet balance',
              );
            }
            return transactionCreated;
          }
          return transactionCreated;
        },
      );
      if (createdTransaction.transactions.isNotEmpty) {
        final transactionModel = TransactionModel.fromTransaction(
          createdTransaction,
        );
        return transactionModel.copyWith(
          transferWallet: transaction.transferWallet,
          transferTransaction: createdTransaction.transactions.isNotEmpty
              ? TransactionModel.fromTransaction(
                  createdTransaction.transactions.first,
                )
              : null,
        );
      }
      return TransactionModel.fromTransaction(createdTransaction);
    } on CreateTransactionFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(CreateTransactionFailure(e), stacktrace);
    }
  }

  static const _updateWalletBalanceQueryAfterTransactionUpdated = '''
    UPDATE wallets
    SET ${WalletFields.walletBalance} = ${WalletFields.walletBalance} - ?1 + ?2,
        ${WalletFields.walletUpdatedAt} = datetime()
    WHERE ${WalletFields.walletId} = ?3
    RETURNING *
  ''';

  static const _updateTransactionQuery = '''
    UPDATE transactions
    SET ${TransactionFields.transactionAmount} = ?1,
        ${TransactionFields.transactionCategoryId} = ?2,
        ${TransactionFields.transactionTransactionType} = ?3,
        ${TransactionFields.transactionNotes} = ?4,
        ${TransactionFields.transactionImageAttachment} = ?5,
        ${TransactionFields.transactionTransactionDate} = ?6,
        ${TransactionFields.transactionUpdatedAt} = datetime()
    WHERE ${TransactionFields.transactionId} = ?7
    RETURNING *
  ''';

  /// Update a transaction.
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      switch (transaction.transactionType) {
        case TransactionTypeEnum.income:
          if (transaction.amount <= 0) {
            throw const UpdateTransactionFailure(
              'Income amount must be positive',
            );
          }
        case TransactionTypeEnum.expense:
          if (transaction.amount >= 0) {
            throw const UpdateTransactionFailure(
              'Expense amount must be negative',
            );
          }
        case TransactionTypeEnum.transfer:
          if (transaction.amount >= 0) {
            throw const UpdateTransactionFailure(
              'Transfer amount must be negative',
            );
          }
          if (transaction.category != null) {
            throw const UpdateTransactionFailure(
              'Category is not allowed for transfer transactions',
            );
          }
        case TransactionTypeEnum.unknown:
          throw const UpdateTransactionFailure(
            'Unknown transaction type',
          );
      }
      final updatedTransaction = await _client.db.writeTransaction((tx) async {
        // Get original transaction to calculate balance adjustment
        final originalTransaction =
            await getTransactionByIdFuture(transaction.id);

        // Update transaction
        final transactionParams = [
          transaction.amount,
          transaction.category?.id,
          transaction.transactionType.jsonKey,
          transaction.notes,
          transaction.imageAttachment,
          transaction.transactionDate.toUtc().toIso8601String(),
          transaction.id,
        ];

        final transactionRows = await tx.execute(
          _query(_updateTransactionQuery, transactionParams),
          transactionParams,
        );

        if (transactionRows.isEmpty) {
          throw UpdateTransactionFailure(
            'Failed to update transaction: ${transaction.notes}',
          );
        }

        final updateWalletBalanceParam = [
          originalTransaction.amount,
          transaction.amount,
          transaction.wallet.id,
        ];

        final rows = await tx.execute(
          _query(
            _updateWalletBalanceQueryAfterTransactionUpdated,
            updateWalletBalanceParam,
          ),
          updateWalletBalanceParam,
        );

        if (rows.isEmpty) {
          throw const UpdateTransactionFailure(
            'Failed to update wallet balance',
          );
        }

        if (transaction.transactionType == TransactionTypeEnum.transfer) {
          // Update destination transaction
          final destinationTransaction = await getTransactionByIdFuture(
            transaction.transferTransaction!.id,
          );

          // Update destination transaction
          final destinationTransactionParams = [
            -transaction.amount,
            transaction.category?.id,
            transaction.transactionType.jsonKey,
            transaction.notes,
            transaction.imageAttachment,
            transaction.transactionDate,
            destinationTransaction.id,
          ];

          await tx.execute(
            _query(_updateTransactionQuery, destinationTransactionParams),
            destinationTransactionParams,
          );

          // Update source transaction transfer transaction
          final destinationWalletBalanceParam = [
            destinationTransaction.amount,
            -transaction.amount,
            destinationTransaction.wallet.id,
          ];

          final rows = await tx.execute(
            _query(
              _updateWalletBalanceQueryAfterTransactionUpdated,
              destinationWalletBalanceParam,
            ),
            destinationWalletBalanceParam,
          );

          if (rows.isEmpty) {
            throw const UpdateTransactionFailure(
              'Failed to update wallet balance',
            );
          }

          final updatedDestinationTransaction = Transaction.fromRow(
            transactionRows.first,
          );

          return Transaction.fromRow(transactionRows.first).copyWith(
            transactionTransferId: updatedDestinationTransaction.id,
            transactions: [
              updatedDestinationTransaction,
            ],
          );
        }

        return Transaction.fromRow(transactionRows.first);
      });

      return TransactionModel.fromTransaction(updatedTransaction);
    } on UpdateTransactionFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(UpdateTransactionFailure(e), stacktrace);
    }
  }

  static const _updateWalletBalanceQueryAfterTransactionDeleted = '''
    UPDATE wallets
    SET ${WalletFields.walletBalance} = ${WalletFields.walletBalance} - ?1,
        ${WalletFields.walletUpdatedAt} = datetime()
    WHERE ${WalletFields.walletId} = ?2
    RETURNING *
  ''';

  static const _deleteTransactionQuery = '''
    DELETE FROM transactions
    WHERE ${TransactionFields.transactionId} = ?1
    RETURNING *
  ''';

  /// Delete a transaction.
  Future<void> deleteTransaction(String id) async {
    try {
      await _client.db.writeTransaction(
        (tx) async {
          // Get original transaction to calculate balance adjustment
          final originalTransaction = await getTransactionByIdFuture(id);

          final params = [id];
          final rows = await tx.execute(
            _query(_deleteTransactionQuery, params),
            params,
          );

          if (rows.isEmpty) {
            throw DeleteTransactionFailure('Failed to delete transaction: $id');
          }

          // Update wallet balance
          final updateWalletBalanceParams = [
            originalTransaction.amount,
            originalTransaction.wallet.id,
          ];

          await tx.execute(
            _query(
              _updateWalletBalanceQueryAfterTransactionDeleted,
              updateWalletBalanceParams,
            ),
            updateWalletBalanceParams,
          );

          if (rows.isEmpty) {
            throw const UpdateTransactionFailure(
              'Failed to update wallet balance',
            );
          }

          if (originalTransaction.transactionType ==
              TransactionTypeEnum.transfer) {
            // Update destination transaction
            final destinationTransaction = await getTransactionByIdFuture(
              originalTransaction.transferTransaction!.id,
            );

            // Delete destination transaction
            await tx.execute(
              _query(_deleteTransactionQuery, [destinationTransaction.id]),
              [destinationTransaction.id],
            );

            // Update destination wallet balance
            final updateDestinationWalletBalanceParams = [
              destinationTransaction.amount,
              originalTransaction.wallet.id,
            ];

            await tx.execute(
              _query(
                _updateWalletBalanceQueryAfterTransactionUpdated,
                updateDestinationWalletBalanceParams,
              ),
              updateDestinationWalletBalanceParams,
            );
          }
        },
      );
    } on DeleteTransactionFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(DeleteTransactionFailure(e), stacktrace);
    }
  }

  /// Query to get transaction summary by categories
  /// Summarizes transaction amounts by category, converting all amounts to a
  /// single currency
  static const String _getTransactionSummaryByCategoryQuery = '''
    SELECT 
      c.${CategoryFields.categoryId} as ${TransactionSummaryByCategoryModelFields.categoryId},
      c.${CategoryFields.categoryName} as ${TransactionSummaryByCategoryModelFields.categoryName},
      c.${CategoryFields.categoryIcon} as ${TransactionSummaryByCategoryModelFields.categoryIcon},
      c.${CategoryFields.categoryColor} as ${TransactionSummaryByCategoryModelFields.categoryColor},
      COUNT(t.${TransactionFields.transactionId}) as ${TransactionSummaryByCategoryModelFields.transactionCount},
      SUM(t.${TransactionFields.transactionAmount}) as ${TransactionSummaryByCategoryModelFields.totalAmount},
      cu.${CurrencyFields.currencyCode} as ${TransactionSummaryByCategoryModelFields.baseCurrencyCode},
      SUM(t.${TransactionFields.transactionAmount} * COALESCE(er.${ExchangeRateFields.exchangeRateRate}, 1.0)) as ${TransactionSummaryByCategoryModelFields.totalAmountExchanged},
      (
        SELECT ${CurrencyFields.currencyCode}
        FROM ${Currency.tableName}
        WHERE ${CurrencyFields.currencyId} = ?1
      ) as ${TransactionSummaryByCategoryModelFields.exchangeCurrencyCode},
      COALESCE(er.${ExchangeRateFields.exchangeRateRate}, 1.0) as ${TransactionSummaryByCategoryModelFields.exchangeRateRate},
      COALESCE(er.${ExchangeRateFields.exchangeRateEffectiveDate}, 
        (
          SELECT MAX(${ExchangeRateFields.exchangeRateEffectiveDate}) 
          FROM ${ExchangeRate.tableName}
          WHERE ${ExchangeRateFields.exchangeRateToCurrency} = ?1
        )
      ) as ${TransactionSummaryByCategoryModelFields.exchangeRateEffectiveDate}
    FROM ${Transaction.tableName} t
    JOIN ${Category.tableName} c ON t.${TransactionFields.transactionCategoryId} = c.${CategoryFields.categoryId}
    JOIN ${Wallet.tableName} w ON t.${TransactionFields.transactionWalletId} = w.${WalletFields.walletId}
    LEFT JOIN ${ExchangeRate.tableName} er ON w.${WalletFields.walletBaseCurrency} = er.${ExchangeRateFields.exchangeRateFromCurrency} 
      AND er.${ExchangeRateFields.exchangeRateToCurrency} = ?1 AND date(er.${ExchangeRateFields.exchangeRateEffectiveDate}) = 
      (
        SELECT MAX(date(${ExchangeRateFields.exchangeRateEffectiveDate})) 
        FROM ${ExchangeRate.tableName}
        WHERE ${ExchangeRateFields.exchangeRateToCurrency} = ?1
      )
    JOIN ${Currency.tableName} cu ON w.${WalletFields.walletBaseCurrency} = cu.${CurrencyFields.currencyId}
    WHERE t.${TransactionFields.transactionUserId} = ?2
      AND t.${TransactionFields.transactionTransactionType} = ?3
      AND (?4 IS NULL OR t.${TransactionFields.transactionTransactionDate} >= ?4)
      AND (?5 IS NULL OR t.${TransactionFields.transactionTransactionDate} <= ?5)
    GROUP BY c.${CategoryFields.categoryId}, er.${ExchangeRateFields.exchangeRateId}, cu.${CurrencyFields.currencyId}
    ORDER BY total_amount DESC
  ''';

  /// Get transaction summary by category.
  Stream<List<TransactionSummaryByCategoryModel>>
      getTransactionSummaryByCategory(
    GetTransactionSummaryByCategoryQuery query,
  ) {
    final params = [
      query.convertToCurrencyId,
      _client.getUserId(),
      query.transactionType?.jsonKey,
      query.startDate?.toUtc().toIso8601String(),
      query.endDate?.toUtc().toIso8601String(),
    ];

    return _client.db
        .watch(
      _query(_getTransactionSummaryByCategoryQuery, params),
      parameters: params,
    )
        .map(
      (results) {
        return results.map(TransactionSummaryByCategoryModel.fromRow).toList();
      },
    );
  }
}

// SELECT c.category_id,c.category_name,c.category_icon,c.category_color, count(t.transaction_id) as transaction_count, (sum(t.transaction_amount) * er.exchange_rate_rate) as total_amount, er.exchange_rate_rate, er.exchange_rate_effective_date
// FROM transactions t
// JOIN categories c ON t.transaction_category_id = c.category_id
// JOIN wallets w ON t.transaction_wallet_id = w.wallet_id
// JOIN exchange_rates er ON w.wallet_base_currency = er.exchange_rate_from_currency 
//     AND er.exchange_rate_to_currency = '4de39ed1-0743-4e90-a234-4788ce1bda77' 
//     AND date(er.exchange_rate_effective_date) = date(now())
// WHERE transaction_transaction_type = 'expense'
// GROUP BY c.category_id, er.exchange_rate_id
