import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/src/models/models.dart';
import 'package:wallet_repository/src/queries/queries.dart';

/// {@template wallet_failure}
/// Base failure class for wallet repository.
/// {@endtemplate}
abstract class WalletFailure with EquatableMixin implements Exception {
  /// {@macro wallet_failure}
  const WalletFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_wallets_failure}
/// Failure when fetching wallets.
/// {@endtemplate}
class GetWalletsFailure extends WalletFailure {
  /// {@macro get_wallets_failure}
  const GetWalletsFailure(super.error);
}

/// {@template get_wallet_by_id_failure}
/// Failure when fetching a wallet by id.
/// {@endtemplate}
class GetWalletByIdFailure extends WalletFailure {
  /// {@macro get_wallet_by_id_failure}
  const GetWalletByIdFailure(super.error);
}

/// {@template get_wallet_by_id_not_found}
///  Failure when fetching a wallet by id and it is not found.
/// {@endtemplate}
class GetWalletByUserIdNotFound extends GetWalletByIdFailure {
  /// {@macro get_wallet_by_id_failure}
  const GetWalletByUserIdNotFound([super.error = 'Wallet not found']);
}

/// {@template get_wallet_by_id_parse_failure}
/// Failure when fetching a wallet by id and it is not found.
/// {@endtemplate}
class GetWalletByUserIdParseFailure extends GetWalletByIdFailure {
  /// {@macro get_wallet_by_id_failure}
  const GetWalletByUserIdParseFailure([super.error = 'Error parsing wallet']);
}

/// {@template create_wallet_failure}
/// Failure when creating a wallet.
/// {@endtemplate}
class CreateWalletFailure extends WalletFailure {
  /// {@macro create_wallet_failure}
  const CreateWalletFailure(super.error);
}

/// {@template update_wallet_failure}
/// Failure when updating a wallet.
/// {@endtemplate}
class UpdateWalletFailure extends WalletFailure {
  /// {@macro update_wallet_failure}
  const UpdateWalletFailure(super.error);
}

/// {@template wallet_repository}
/// A wallet repository.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  WalletRepository({
    required FelicashDataClient client,
  }) : _client = client;

  final FelicashDataClient _client;

  String _query(String query, [List<dynamic>? params]) {
    if (kDebugMode) {
      final loggedQuery = _formatQueryWithParams(query, params);
      log('[WalletRepository]: $loggedQuery');
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
  static const _getWalletsQuery = '''
    SELECT * 
    FROM wallets w 
    LEFT JOIN credit_wallets cw ON w.${WalletFields.walletId} = cw.${CreditWalletFields.creditWalletWalletId} 
    LEFT JOIN savings_wallets sw ON w.${WalletFields.walletId} = sw.${SavingsWalletFields.savingsWalletWalletId}
    LEFT JOIN currencies c ON w.${WalletFields.walletBaseCurrency} = c.${CurrencyFields.currencyId}
    WHERE w.${WalletFields.walletUserId} = ?1 
          AND (?2 is null OR w.${WalletFields.walletName} LIKE ?2) 
          AND (?3 is null OR w.${WalletFields.walletDescription} LIKE ?3) 
          AND (?4 is null OR w.${WalletFields.walletBaseCurrency} LIKE ?4) 
          AND (?5 is null OR w.${WalletFields.walletBalance} >= ?5) 
          AND (?6 is null OR w.${WalletFields.walletBalance} <= ?6) 
          AND (?7 is null OR w.${WalletFields.walletWalletType} = ?7) 
          AND (?8 is null OR w.${WalletFields.walletArchived} = ?8)
    ORDER BY 
      CASE WHEN ?9 IS NOT NULL AND ?10 = 'ASC' THEN ?9 END ASC,
      CASE WHEN ?9 IS NOT NULL AND ?10 = 'DESC' THEN ?9 END DESC
    LIMIT ?11 OFFSET ?12
  ''';

  /// Fetches all wallets.
  ///
  /// Throws a [GetWalletsFailure] if an error occurs.
  Stream<List<BaseWalletModel>> getWalletsStream(GetWalletQuery query) {
    final params = [
      _client.getUserId(),
      query.name,
      query.description,
      query.baseCurrency,
      query.minBalance,
      query.maxBalance,
      query.walletType?.jsonKey,
      query.archived,
      query.orderBy,
      query.orderType.sqlString,
      query.limit,
      query.offset,
    ];

    return _client.db
        .watch(
      _query(_getWalletsQuery, params),
      parameters: params,
    )
        .map((results) {
      final walletMap = _processWalletRows(results);
      final wallets = walletMap.values.toList();
      final walletModels = <BaseWalletModel>[];
      for (final wallet in wallets) {
        final walletModel = switch (wallet.walletWalletType) {
          WalletType.basic => BasicWalletModel.fromWallet(wallet: wallet),
          WalletType.credit => CreditWalletModel.fromWallet(wallet: wallet),
          WalletType.savings => SavingsWalletModel.fromWallet(wallet: wallet),
          _ => throw UnimplementedError(
              'Wallet type ${wallet.walletWalletType} is not implemented.',
            ),
        };
        walletModels.add(walletModel);
      }
      return walletModels;
    }).handleError(
      (Object e, StackTrace stacktrace) {
        if (e is GetWalletsFailure) throw e;
        Error.throwWithStackTrace(GetWalletsFailure(e), stacktrace);
      },
    );
  }

  /// Fetches all wallets as a Future.
  ///
  /// Throws a [GetWalletsFailure] if an error occurs.
  Future<List<BaseWalletModel>> getWalletsFuture(GetWalletQuery query) async {
    final params = [
      _client.getUserId(),
      query.name,
      query.description,
      query.baseCurrency,
      query.minBalance,
      query.maxBalance,
      query.walletType?.jsonKey,
      query.archived,
      query.orderBy,
      query.orderType.sqlString,
      query.limit,
      query.offset,
    ];

    try {
      final results = await _client.db.getAll(
        _query(_getWalletsQuery, params),
        params,
      );

      final walletMap = _processWalletRows(results);
      final wallets = walletMap.values.toList();
      final walletModels = <BaseWalletModel>[];

      for (final wallet in wallets) {
        final walletModel = switch (wallet.walletWalletType) {
          WalletType.basic => BasicWalletModel.fromWallet(wallet: wallet),
          WalletType.credit => CreditWalletModel.fromWallet(wallet: wallet),
          WalletType.savings => SavingsWalletModel.fromWallet(wallet: wallet),
          _ => throw UnimplementedError(
              'Wallet type ${wallet.walletWalletType} is not implemented.',
            ),
        };
        walletModels.add(walletModel);
      }

      return walletModels;
    } catch (e, stacktrace) {
      if (e is GetWalletsFailure) rethrow;
      Error.throwWithStackTrace(GetWalletsFailure(e), stacktrace);
    }
  }

  static const _getWalletByIdQuery = '''
    SELECT *
    FROM wallets w 
    LEFT JOIN credit_wallets cw ON w.${WalletFields.walletId} = cw.${CreditWalletFields.creditWalletWalletId} 
    LEFT JOIN savings_wallets sw ON w.${WalletFields.walletId} = sw.${SavingsWalletFields.savingsWalletWalletId}
    LEFT JOIN currencies c ON w.${WalletFields.walletBaseCurrency} = c.${CurrencyFields.currencyId}
    WHERE w.${WalletFields.walletId} = ?1
  ''';

  /// Fetches a wallet by id.
  ///
  /// Throws a [GetWalletByIdFailure] if an error occurs.
  Stream<BaseWalletModel> getWalletById(String id) {
    final params = [id];
    return _client.db
        .watch(
      _query(_getWalletByIdQuery, params),
      parameters: params,
    )
        .map((row) {
      if (row.isEmpty) throw const GetWalletByUserIdNotFound();

      final walletMap = _processWalletRow(row.first);

      if (walletMap.isEmpty) {
        throw const GetWalletByUserIdParseFailure();
      }

      final wallet = walletMap.values.first;

      return switch (wallet.walletWalletType) {
        WalletType.basic => BasicWalletModel.fromWallet(wallet: wallet),
        WalletType.credit => CreditWalletModel.fromWallet(wallet: wallet),
        WalletType.savings => SavingsWalletModel.fromWallet(wallet: wallet),
        _ => throw UnimplementedError(
            'Wallet type ${wallet.walletWalletType} is not implemented.',
          ),
      };
    }).handleError(
      (Object e, StackTrace stacktrace) {
        if (e is GetWalletByUserIdNotFound) throw e;
        Error.throwWithStackTrace(GetWalletByIdFailure(e), stacktrace);
      },
    );
  }

  static const _insertWalletQuery = '''
    INSERT INTO wallets (
      ${WalletFields.id},
      ${WalletFields.walletId},
      ${WalletFields.walletUserId}, 
      ${WalletFields.walletName}, 
      ${WalletFields.walletDescription}, 

      ${WalletFields.walletBaseCurrency}, 
      ${WalletFields.walletBalance}, 
      ${WalletFields.walletWalletType},
      ${WalletFields.walletIcon},
      ${WalletFields.walletColor},

      ${WalletFields.walletExcludeFromTotal},
      ${WalletFields.walletArchived},
      ${WalletFields.walletCreatedAt},
      ${WalletFields.walletUpdatedAt},
      ${WalletFields.walletArchivedAt},
      
      ${WalletFields.walletArchiveReason}
    )
    VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, false, datetime(), datetime(), null, null)
    RETURNING *
  ''';

  static const _insertCreditWalletQuery = '''
    INSERT INTO credit_wallets (
      ${CreditWalletFields.id},
      ${CreditWalletFields.creditWalletId},
      ${CreditWalletFields.creditWalletWalletId},
      ${CreditWalletFields.creditWalletCreditLimit},
      ${CreditWalletFields.creditWalletPaymentDueDayOfMonth},
      ${CreditWalletFields.creditWalletStateDayOfMonth}
    )
    VALUES (uuid(), uuid(), ?1, ?2, ?3, ?4) RETURNING *
  ''';

  static const _insertSavingsWalletQuery = '''
    INSERT INTO savings_wallets (
      ${SavingsWalletFields.id},
      ${SavingsWalletFields.savingsWalletId},
      ${SavingsWalletFields.savingsWalletWalletId},
      ${SavingsWalletFields.savingsWalletSavingsGoal}
    ) 
    VALUES (uuid(), uuid(), ?1, ?2) RETURNING *
  ''';

  static const _getCurrencyQuery = '''
    SELECT * FROM currencies WHERE ${CurrencyFields.currencyId} =?1
  ''';

  /// Creates a wallet.
  ///
  /// Throws a [CreateWalletFailure] if an error occurs.
  Future<BaseWalletModel> createWallet(BaseWalletModel wallet) async {
    try {
      final createdWallet = await _client.db.writeTransaction(
        (tx) async {
          // Create base wallet
          final walletParams = [
            wallet.id,
            wallet.id,
            _client.getUserId(),
            wallet.name,
            wallet.description,
            //
            wallet.baseCurrency.id,
            wallet.balance,
            wallet.walletType.jsonKey,
            wallet.icon.toRaw(),
            wallet.color.toHex(),
            //
            wallet.excludeFromTotal,
          ];

          final walletRows = await tx.execute(
            _query(_insertWalletQuery, walletParams),
            walletParams,
          );

          if (walletRows.isEmpty) {
            throw CreateWalletFailure(
              'Failed to create wallet: ${wallet.name}',
            );
          }

          var createdWallet = Wallet.fromRow(walletRows.first);

          final currencyParams = [wallet.baseCurrency.id];
          final currencyRows = await tx.execute(
            _query(_getCurrencyQuery, currencyParams),
            currencyParams,
          );
          if (currencyRows.isEmpty) {
            throw CreateWalletFailure(
              'Failed to create wallet: ${wallet.name}',
            );
          }
          final currency = Currency.fromRow(currencyRows.first);

          createdWallet = createdWallet.copyWith(
            currencies: [currency],
          );

          if (wallet is BasicWalletModel) {
            return createdWallet;
          }

          // Handle specific wallet types
          if (wallet is CreditWalletModel) {
            final creditParams = [
              createdWallet.walletId,
              wallet.creditLimit,
              wallet.paymentDueDayOfMonth,
              wallet.stateDayOfMonth,
            ];

            final creditWalletRows = await tx.execute(
              _query(_insertCreditWalletQuery, creditParams),
              creditParams,
            );

            if (creditWalletRows.isEmpty) {
              throw CreateWalletFailure(
                'Failed to create credit wallet for wallet: '
                '${createdWallet.walletName}',
              );
            }

            final createdCreditWallet =
                CreditWallet.fromRow(creditWalletRows.first);

            return createdWallet.copyWith(
              creditWallets: [createdCreditWallet],
            );
          } else if (wallet is SavingsWalletModel) {
            final savingsParams = [
              createdWallet.walletId,
              wallet.savingsGoal,
            ];

            final savingsWalletRows = await tx.execute(
              _query(_insertSavingsWalletQuery, savingsParams),
              savingsParams,
            );

            if (savingsWalletRows.isEmpty) {
              throw CreateWalletFailure(
                'Failed to create savings wallet for wallet: '
                '${createdWallet.walletName}',
              );
            }

            final createdSavingsWallet =
                SavingsWallet.fromRow(savingsWalletRows.first);

            return createdWallet.copyWith(
              savingsWallets: [createdSavingsWallet],
            );
          }
        },
      );
      if (createdWallet == null) {
        throw const CreateWalletFailure('Failed to create wallet');
      }
      return switch (createdWallet.walletWalletType) {
        WalletType.basic => BasicWalletModel.fromWallet(
            wallet: createdWallet,
          ),
        WalletType.credit => CreditWalletModel.fromWallet(
            wallet: createdWallet,
          ),
        WalletType.savings => SavingsWalletModel.fromWallet(
            wallet: createdWallet,
          ),
        _ => throw UnimplementedError(
            'Wallet type ${createdWallet.walletWalletType} is not implemented.',
          )
      };
    } on CreateWalletFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(CreateWalletFailure(e), stacktrace);
    }
  }

  static const _updateWalletQuery = '''
    UPDATE wallets
    SET 
    CASE 
      WHEN ?1 IS NOT NULL THEN ${WalletFields.walletName} =?1
      WHEN ?2 IS NOT NULL THEN ${WalletFields.walletDescription} =?2
      WHEN ?3 IS NOT NULL THEN ${WalletFields.walletBalance} =?3
      WHEN ?4 IS NOT NULL THEN ${WalletFields.walletBaseCurrency} =?4
      WHEN ?5 IS NOT NULL THEN ${WalletFields.walletWalletType} =?5

      WHEN ?6 IS NOT NULL THEN ${WalletFields.walletIcon} =?6
      WHEN ?7 IS NOT NULL THEN ${WalletFields.walletColor} =?7
      WHEN ?8 IS NOT NULL THEN ${WalletFields.walletExcludeFromTotal} =?8
      WHEN ?9 IS NOT NULL THEN ${WalletFields.walletArchived} =?9
      WHEN ?10 IS NOT NULL THEN ${WalletFields.walletArchivedAt} =?10
      
      WHEN ?11 IS NOT NULL THEN ${WalletFields.walletArchiveReason} =?11
    END,
    ${WalletFields.walletUpdatedAt} =?12
    WHERE ${WalletFields.walletId} =?13
    RETURNING *
    ''';

  static const _updateCreditWalletQuery = '''
    UPDATE credit_wallets
    SET 
    CASE
      WHEN ?1 IS NOT NULL THEN ${CreditWalletFields.creditWalletCreditLimit} =?1
      WHEN ?2 IS NOT NULL THEN ${CreditWalletFields.creditWalletPaymentDueDayOfMonth} =?2
      WHEN ?3 IS NOT NULL THEN ${CreditWalletFields.creditWalletStateDayOfMonth} =?3
    END,
    WHERE ${CreditWalletFields.creditWalletWalletId} =?5
    RETURNING *
  ''';

  static const _updateSavingsWalletQuery = '''
    UPDATE savings_wallets
    SET 
    CASE 
      WHEN ?1 IS NOT NULL THEN ${SavingsWalletFields.savingsWalletSavingsGoal} =?1
    END,
    WHERE ${SavingsWalletFields.savingsWalletWalletId} =?2
    RETURNING *
  ''';

  /// Updates a wallet.
  ///
  /// Throws a [UpdateWalletFailure] if an error occurs.
  Future<BaseWalletModel> updateWallet(BaseWalletModel wallet) async {
    try {
      final updatedWallet = await _client.db.writeTransaction((tx) async {
        final walletParams = [
          wallet.name,
          wallet.description,
          wallet.balance,
          wallet.baseCurrency.id,
          wallet.walletType.jsonKey,
          //
          wallet.icon.toRaw(),
          wallet.color.toHex(),
          wallet.excludeFromTotal,
          wallet.isArchived,
          wallet.archivedAt,
          //
          wallet.achieveReason,
          DateTime.now().toIso8601String(),
          wallet.id,
        ];
        final walletRows = await tx.execute(
          _query(_updateWalletQuery, walletParams),
          walletParams,
        );
        if (walletRows.isEmpty) {
          throw UpdateWalletFailure(
            'Failed to update wallet: ${wallet.name}',
          );
        }
        final updatedWallet = Wallet.fromRow(walletRows.first);
        if (wallet is BasicWalletModel) {
          return updatedWallet;
        }
        // Handle specific wallet types
        if (wallet is CreditWalletModel) {
          final creditParams = [
            wallet.creditLimit,
            wallet.paymentDueDayOfMonth,
            wallet.stateDayOfMonth,
            wallet.id,
          ];
          final creditWalletRows = await tx.execute(
            _query(_updateCreditWalletQuery, creditParams),
            creditParams,
          );
          if (creditWalletRows.isEmpty) {
            throw UpdateWalletFailure(
              'Failed to update credit wallet for wallet: ${wallet.name}',
            );
          }
          final updatedCreditWallet =
              CreditWallet.fromRow(creditWalletRows.first);
          return updatedWallet.copyWith(
            creditWallets: [updatedCreditWallet],
          );
        } else if (wallet is SavingsWalletModel) {
          final savingsParams = [
            wallet.savingsGoal,
            wallet.id,
          ];
          final savingsWalletRows = await tx.execute(
            _query(_updateSavingsWalletQuery, savingsParams),
            savingsParams,
          );
          if (savingsWalletRows.isEmpty) {
            throw UpdateWalletFailure(
              'Failed to update savings wallet for wallet: ${wallet.name}',
            );
          }
          final updatedSavingsWallet =
              SavingsWallet.fromRow(savingsWalletRows.first);
          return updatedWallet.copyWith(
            savingsWallets: [updatedSavingsWallet],
          );
        }
      });
      if (updatedWallet == null) {
        throw const UpdateWalletFailure('Failed to update wallet');
      }
      return switch (updatedWallet.walletWalletType) {
        WalletType.basic => BasicWalletModel.fromWallet(
            wallet: updatedWallet,
          ),
        WalletType.credit => CreditWalletModel.fromWallet(
            wallet: updatedWallet,
          ),
        WalletType.savings => SavingsWalletModel.fromWallet(
            wallet: updatedWallet,
          ),
        _ => throw UnimplementedError(
            'Wallet type ${updatedWallet.walletWalletType} is not implemented.',
          )
      };
    } on UpdateWalletFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(UpdateWalletFailure(e), stacktrace);
    }
  }

  // Process wallet rows and organize them into a map by wallet ID
  Map<String, Wallet> _processWalletRows(SqliteResultSet rows) {
    final walletMap = <String, Wallet>{};

    for (final row in rows) {
      final walletId = row[WalletFields.walletId] as String;

      // Add wallet if not already in the map
      if (!walletMap.containsKey(walletId)) {
        walletMap[walletId] = Wallet.fromRow(row);
      }

      // Add credit wallet if applicable
      if (_isWalletOfType(row, WalletType.credit)) {
        _addCreditWalletToMap(walletMap, walletId, row);
      }
      // Add savings wallet if applicable
      else if (_isWalletOfType(row, WalletType.savings)) {
        _addSavingsWalletToMap(walletMap, walletId, row);
      }

      _addCurrencyToMap(walletMap, row);
    }

    return walletMap;
  }

  // Process a single wallet row and organize it into a map by wallet ID
  Map<String, Wallet> _processWalletRow(SqliteRow row) {
    final walletMap = <String, Wallet>{};
    final walletId = row[WalletFields.walletId] as String;

    // Add wallet if not already in the map
    if (!walletMap.containsKey(walletId)) {
      walletMap[walletId] = Wallet.fromRow(row);
    }

    // Add credit wallet if applicable
    if (_isWalletOfType(row, WalletType.credit)) {
      _addCreditWalletToMap(walletMap, walletId, row);
    }
    // Add savings wallet if applicable
    else if (_isWalletOfType(row, WalletType.savings)) {
      _addSavingsWalletToMap(walletMap, walletId, row);
    }

    // Map currencies to the wallet
    _addCurrencyToMap(walletMap, row);
    return walletMap;
  }

  // Check if a row represents a specific wallet type
  bool _isWalletOfType(Map<String, dynamic> row, WalletType type) {
    return row.containsKey(WalletFields.walletWalletType) &&
        row[WalletFields.walletWalletType] == type.jsonKey;
  }

  // Add a credit wallet to the wallet map
  void _addCreditWalletToMap(
    Map<String, Wallet> walletMap,
    String walletId,
    SqliteRow row,
  ) {
    final creditWallet = CreditWallet.fromRow(row);
    final wallet = walletMap[walletId];

    if (wallet == null) {
      throw Exception('Wallet not found for ID: $walletId');
    }

    // Add credit wallet if not already in the list
    if (!wallet.creditWallets.any(
      (cw) => cw.creditWalletWalletId == creditWallet.creditWalletWalletId,
    )) {
      walletMap[walletId] = wallet.copyWith(
        creditWallets: [...wallet.creditWallets, creditWallet],
      );
    }
  }

  // Add a savings wallet to the wallet map
  void _addSavingsWalletToMap(
    Map<String, Wallet> walletMap,
    String walletId,
    SqliteRow row,
  ) {
    final savingsWallet = SavingsWallet.fromRow(row);
    final wallet = walletMap[walletId];

    if (wallet == null) {
      throw Exception('Wallet not found for ID: $walletId');
    }

    // Add savings wallet if not already in the list
    if (!wallet.savingsWallets.any(
      (sw) => sw.savingsWalletWalletId == savingsWallet.savingsWalletWalletId,
    )) {
      walletMap[walletId] = wallet.copyWith(
        savingsWallets: [...wallet.savingsWallets, savingsWallet],
      );
    }
  }

  // Add a currency to the wallet map
  void _addCurrencyToMap(
    Map<String, Wallet> walletMap,
    SqliteRow row,
  ) {
    final walletId = row[WalletFields.walletId] as String;
    final wallet = walletMap[walletId];

    if (wallet == null) {
      throw Exception('Wallet not found for ID: $walletId');
    }

    final currency = Currency.fromRow(row);

    walletMap[walletId] = wallet.copyWith(
      currencies: [...wallet.currencies, currency],
    );
  }
}
