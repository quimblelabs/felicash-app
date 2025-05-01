import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:user_setting_repository/src/models/user_settings_model.dart';

/// {@template transaction_failure}
/// Base failure class for transaction repository.
/// {@endtemplate}
abstract class UserSettingFailure with EquatableMixin implements Exception {
  /// {@macro user_setting_failure}
  const UserSettingFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_user_setting_failure}
/// Failure when fetching user setting.
/// {@endtemplate}
class GetUserSettingFailure extends UserSettingFailure {
  /// {@macro get_user_setting_failure}
  const GetUserSettingFailure(super.error);
}

/// {@template create_user_setting_failure}
/// Failure when creating user setting.
/// {@endtemplate}
class CreateUserSettingFailure extends UserSettingFailure {
  /// {@macro create_user_setting_failure}
  const CreateUserSettingFailure(super.error);
}

/// {@template update_user_setting_failure}
/// Failure when updating user setting.
/// {@endtemplate}
class UpdateUserSettingFailure extends UserSettingFailure {
  /// {@macro update_user_setting_failure}
  const UpdateUserSettingFailure(super.error);
}

/// {@template user_setting_repository}
/// A repository for user setting.
/// {@endtemplate}
class UserSettingRepository {
  /// {@macro user_setting_repository}
  UserSettingRepository({
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

  static const _getUserSettingQuery = '''
  SELECT * FROM ${UserSetting.tableName} WHERE ${UserSettingFields.userSettingUserId} = ?1 LIMIT 1;
  ''';

  /// Get user setting as a stream.
  Stream<UserSettingsModel?> getUserSettingStream() {
    try {
      final params = [
        _client.getUserId(),
      ];
      final stream = _client.db.watch(
        _query(
          _getUserSettingQuery,
          params,
        ),
        parameters: params,
      );
      return stream.map(
        (results) {
          final result = results.firstOrNull;
          if (result == null) return null;
          final userSetting = UserSetting.fromRow(result);
          return UserSettingsModel.fromUserSetting(userSetting);
        },
      );
    } catch (e, stackTrace) {
      if (e is GetUserSettingFailure) rethrow;
      Error.throwWithStackTrace(
        GetUserSettingFailure(e),
        stackTrace,
      );
    }
  }

  /// Get user setting as a future.
  Future<UserSettingsModel?> getUserSettingFuture() async {
    try {
      final params = [
        _client.getUserId(),
      ];
      final results = await _client.db.getAll(
        _query(
          _getUserSettingQuery,
          params,
        ),
        params,
      );
      final result = results.firstOrNull;
      if (result == null) return null;
      final userSetting = UserSetting.fromRow(result);
      return UserSettingsModel.fromUserSetting(userSetting);
    } catch (e, stackTrace) {
      if (e is GetUserSettingFailure) rethrow;
      Error.throwWithStackTrace(
        GetUserSettingFailure(e),
        stackTrace,
      );
    }
  }

  static const _insertUserSettingQuery = '''
  INSERT INTO ${UserSetting.tableName} 
  (
    ${UserSettingFields.id},
    ${UserSettingFields.userSettingId},
    ${UserSettingFields.userSettingUserId}, 
    ${UserSettingFields.userSettingTheme}, 
    ${UserSettingFields.userSettingLanguageCode}, 

    ${UserSettingFields.userSettingDefaultWallet}, 
    ${UserSettingFields.userSettingBaseCurrencyCode}, 
    ${UserSettingFields.userSettingDateFormat}, 
    ${UserSettingFields.userSettingMonetaryFormat}, 
    ${UserSettingFields.userSettingCreatedAt},

    ${UserSettingFields.userSettingUpdatedAt}
  ) 
  VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)
  ''';

  /// Create user setting.
  Future<void> createUserSetting(UserSettingsModel userSettings) async {
    try {
      final now = DateTime.now().toUtc();
      final params = [
        userSettings.id,
        userSettings.id,
        _client.getUserId(),
        userSettings.theme,
        userSettings.language,
        userSettings.defaultWalletId,
        userSettings.currency,
        userSettings.txDateFormat,
        userSettings.monetaryFormat,
        now.toIso8601String(),
        now.toIso8601String(),
      ];
      await _client.db.writeTransaction(
        (tx) async {
          await tx.execute(
            _query(
              _insertUserSettingQuery,
              params,
            ),
            params,
          );
        },
      );
    } catch (e, stackTrace) {
      if (e is CreateUserSettingFailure) rethrow;
      Error.throwWithStackTrace(
        CreateUserSettingFailure(e),
        stackTrace,
      );
    }
  }

  static const _updateUserSettingQuery = '''
  UPDATE ${UserSetting.tableName} 
  SET 
    ${UserSettingFields.userSettingTheme} = ?1, 
    ${UserSettingFields.userSettingLanguageCode} = ?2, 
    ${UserSettingFields.userSettingDefaultWallet} = ?3, 
    ${UserSettingFields.userSettingBaseCurrencyCode} = ?4, 
    ${UserSettingFields.userSettingDateFormat} = ?5, 
    ${UserSettingFields.userSettingMonetaryFormat} = ?6, 
    ${UserSettingFields.userSettingUpdatedAt} = ?7
  WHERE ${UserSettingFields.userSettingUserId} = ?8
  RETURNING *
  ''';

  /// Update user setting.
  Future<void> updateUserSetting(UserSettingsModel userSettings) async {
    try {
      final params = [
        userSettings.theme,
        userSettings.language,
        userSettings.defaultWalletId,
        userSettings.currency,
        userSettings.txDateFormat,
        userSettings.monetaryFormat,
        DateTime.now().toUtc().toIso8601String(),
        _client.getUserId(),
      ];
      await _client.db.writeTransaction(
        (tx) async {
          await tx.execute(
            _query(
              _updateUserSettingQuery,
              params,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      if (e is UpdateUserSettingFailure) rethrow;
      Error.throwWithStackTrace(
        UpdateUserSettingFailure(e),
        stackTrace,
      );
    }
  }
}
