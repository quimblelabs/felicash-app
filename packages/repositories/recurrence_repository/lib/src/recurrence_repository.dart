import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'models/recurrence_model.dart';

/// {@template recurrence_failure}
/// Base failure class for recurrence repository.
/// {@endtemplate}
abstract class RecurrenceFailure with EquatableMixin implements Exception {
  /// {@macro recurrence_failure}
  const RecurrenceFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_recurrences_failure}
/// Failure when fetching recurrences.
/// {@endtemplate}
class GetRecurrencesFailure extends RecurrenceFailure {
  /// {@macro get_recurrences_failure}
  const GetRecurrencesFailure(super.error);
}

/// {@template get_recurrence_by_id_failure}
/// Failure when fetching a recurrence by id.
/// {@endtemplate}
class GetRecurrenceByIdFailure extends RecurrenceFailure {
  /// {@macro get_recurrence_by_id_failure}
  const GetRecurrenceByIdFailure(super.error);
}

/// {@template create_recurrence_failure}
/// Failure when creating a recurrence.
/// {@endtemplate}
class CreateRecurrenceFailure extends RecurrenceFailure {
  /// {@macro create_recurrence_failure}
  const CreateRecurrenceFailure(super.error);
}

/// {@template update_recurrence_failure}
/// Failure when updating a recurrence.
/// {@endtemplate}
class UpdateRecurrenceFailure extends RecurrenceFailure {
  /// {@macro update_recurrence_failure}
  const UpdateRecurrenceFailure(super.error);
}

/// {@template delete_recurrence_failure}
/// Failure when deleting a recurrence.
/// {@endtemplate}
class DeleteRecurrenceFailure extends RecurrenceFailure {
  /// {@macro delete_recurrence_failure}
  const DeleteRecurrenceFailure(super.error);
}

class RecurrenceRepository {
  /// {@macro recurrence_repository}
  RecurrenceRepository({required FelicashDataClient client}) : _client = client;

  final FelicashDataClient _client;

  String _query(String query, [List<dynamic>? params]) {
    if (foundation.kDebugMode) {
      final loggedQuery = _formatQueryWithParams(query, params);
      log('[RecurrenceRepository]: $loggedQuery');
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

  static const _getRecurrenceByIdQuery = '''
    SELECT *
    FROM recurrences r
    WHERE r.${RecurrenceFields.recurrenceId} = ?1
  ''';

  Stream<RecurrenceModel> getRecurrenceById(String id) {
    final params = [id];
    return _client.db
        .watch(_query(_getRecurrenceByIdQuery, params), parameters: params)
        .map((results) {
          if (results.isEmpty) {
            throw GetRecurrenceByIdFailure('Recurrence not found');
          }
          final row = results.first;
          final recurrence = Recurrence.fromRow(row);
          final recurrenceModel = RecurrenceModel.fromRecurrence(recurrence);
          return recurrenceModel;
        })
        .handleError((Object e, StackTrace stacktrace) {
          if (e is GetRecurrenceByIdFailure) throw e;
          Error.throwWithStackTrace(GetRecurrenceByIdFailure(e), stacktrace);
        });
  }

  static const _createRecurrenceQuery = '''
    INSERT INTO recurrences (
      ${RecurrenceFields.id},
      ${RecurrenceFields.recurrenceId},
      ${RecurrenceFields.recurrenceUserId},
      ${RecurrenceFields.recurrenceCronString},
      ${RecurrenceFields.recurrenceRecurrenceType},
      ${RecurrenceFields.recurrenceDescription},
      ${RecurrenceFields.recurrenceCreatedAt},
      ${RecurrenceFields.recurrenceUpdatedAt}
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, datetime(), datetime())
    RETURNING *
  ''';

  Future<RecurrenceModel> createRecurrence(RecurrenceModel recurrence) async {
    try {
      final createdRecurrence = await _client.db.writeTransaction<Recurrence>((
        tx,
      ) async {
        final params = [
          recurrence.id,
          recurrence.id,
          _client.getUserId(),
          recurrence.cronString,
          recurrence.recurrenceType.name,
          recurrence.description,
        ];
        final rows = await tx.execute(
          _query(_createRecurrenceQuery, params),
          params,
        );
        if (rows.isEmpty) {
          throw CreateRecurrenceFailure('Failed to create recurrence');
        }
        final row = rows.first;
        return Recurrence.fromRow(row);
      });
      final recurrenceModel = RecurrenceModel.fromRecurrence(createdRecurrence);
      return recurrenceModel;
    } on CreateRecurrenceFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(CreateRecurrenceFailure(e), stacktrace);
    }
  }

  static const _updateRecurrenceQuery = '''
    UPDATE recurrences
    SET
      ${RecurrenceFields.recurrenceCronString} = ?1,
      ${RecurrenceFields.recurrenceRecurrenceType} = ?2,
      ${RecurrenceFields.recurrenceDescription} = ?3,
      ${RecurrenceFields.recurrenceUpdatedAt} = datetime()
    WHERE ${RecurrenceFields.recurrenceId} = ?4
    RETURNING *
  ''';

  Future<RecurrenceModel> updateRecurrence(RecurrenceModel recurrence) async {
    try {
      final updatedRecurrence = await _client.db.writeTransaction<Recurrence>((
        tx,
      ) async {
        final params = [
          recurrence.cronString,
          recurrence.recurrenceType.name,
          recurrence.description,
          recurrence.id,
        ];
        final rows = await tx.execute(
          _query(_updateRecurrenceQuery, params),
          params,
        );
        if (rows.isEmpty) {
          throw UpdateRecurrenceFailure('Failed to update recurrence');
        }
        final row = rows.first;
        return Recurrence.fromRow(row);
      });
      final recurrenceModel = RecurrenceModel.fromRecurrence(updatedRecurrence);
      return recurrenceModel;
    } on UpdateRecurrenceFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(UpdateRecurrenceFailure(e), stacktrace);
    }
  }

  static const _deleteRecurrenceQuery = '''
    DELETE FROM recurrences
    WHERE ${RecurrenceFields.recurrenceId} = ?1
  ''';

  Future<void> deleteRecurrence(String id) async {
    try {
      await _client.db.writeTransaction((tx) async {
        final params = [id];
        await tx.execute(_query(_deleteRecurrenceQuery, params), params);
      });
    } on DeleteRecurrenceFailure {
      rethrow;
    } catch (e, stacktrace) {
      Error.throwWithStackTrace(DeleteRecurrenceFailure(e), stacktrace);
    }
  }
}
