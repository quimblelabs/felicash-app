import 'package:felicash_data_client/src/enums/recurrence_type.dart';
import 'package:felicash_data_client/src/models/profile.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recurrence.g.dart';

/// {@template recurrence_fields}
/// Recurrence fields
/// {@endtemplate}
typedef RecurrenceFields = _$RecurrenceJsonKeys;

/// {@template recurrence_model}
/// Recurrence model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Recurrence {
  /// {@macro recurrence_model}
  const Recurrence({
    required this.recurrenceId,
    required this.recurrenceCronString,
    required this.recurrenceRecurrenceType,
    required this.recurrenceDescription,
    required this.recurrenceCreatedAt,
    required this.recurrenceUpdatedAt,
    required this.recurrenceUserId,
    this.profiles = const [],
  }) : id = recurrenceId;

  /// Factory constructor for [Recurrence] from [SqliteRow]
  factory Recurrence.fromRow(SqliteRow row) {
    return Recurrence(
      recurrenceId: row[RecurrenceFields.recurrenceId] as String,
      recurrenceCronString:
          row[RecurrenceFields.recurrenceCronString] as String,
      recurrenceRecurrenceType:
          RecurrenceType.values[row[RecurrenceFields.recurrenceRecurrenceType]
              as int],
      recurrenceDescription:
          row[RecurrenceFields.recurrenceDescription] as String?,
      recurrenceCreatedAt: DateTime.parse(
        row[RecurrenceFields.recurrenceCreatedAt] as String,
      ),
      recurrenceUpdatedAt: DateTime.parse(
        row[RecurrenceFields.recurrenceUpdatedAt] as String,
      ),
      recurrenceUserId: row[RecurrenceFields.recurrenceUserId] as String,
      profiles: [],
    );
  }

  /// Table name of the recurrence
  static const String tableName = 'recurrences';

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the recurrence
  final String recurrenceId;

  /// Cron string of the recurrence
  /// This is the cron string of the recurrence
  final String recurrenceCronString;

  /// Recurrence type of the recurrence
  /// This is the recurrence type of the recurrence
  final RecurrenceType recurrenceRecurrenceType;

  /// Description of the recurrence
  final String? recurrenceDescription;

  /// Created at of the recurrence
  final DateTime recurrenceCreatedAt;

  /// Updated at of the recurrence
  final DateTime recurrenceUpdatedAt;

  /// User id of the recurrence
  final String recurrenceUserId;

  /// Profile of the recurrence
  /// This is the profile of the user who created the recurrence
  final List<Profile> profiles;

  /// Creates a copy of this [Recurrence] but with the given fields
  Recurrence copyWith({
    String? recurrenceId,
    String? recurrenceCronString,
    RecurrenceType? recurrenceRecurrenceType,
    String? recurrenceDescription,
    DateTime? recurrenceCreatedAt,
    DateTime? recurrenceUpdatedAt,
    String? recurrenceUserId,
    List<Profile>? profiles,
  }) {
    return Recurrence(
      recurrenceId: recurrenceId ?? this.recurrenceId,
      recurrenceCronString: recurrenceCronString ?? this.recurrenceCronString,
      recurrenceRecurrenceType:
          recurrenceRecurrenceType ?? this.recurrenceRecurrenceType,
      recurrenceDescription:
          recurrenceDescription ?? this.recurrenceDescription,
      recurrenceCreatedAt: recurrenceCreatedAt ?? this.recurrenceCreatedAt,
      recurrenceUpdatedAt: recurrenceUpdatedAt ?? this.recurrenceUpdatedAt,
      recurrenceUserId: recurrenceUserId ?? this.recurrenceUserId,
      profiles: profiles ?? this.profiles,
    );
  }
}
