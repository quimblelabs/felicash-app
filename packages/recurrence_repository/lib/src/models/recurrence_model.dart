// Table recurrences {
//   id UUID [pk, note: 'Primary key for the recurrence']
//   user_id UUID [not null, note: 'Reference to the user who created the recurrence']
//   cron_string TEXT [null, note: 'Cron expression defining the recurrence pattern']
//   recurrence_type recurrenceType [not null, note: 'Type of recurrence pattern']
//   description VARCHAR255 [not null, note: 'Human-readable description of the recurrence']
//   created_at TIMESTAMP [default: `now()`, note: 'Timestamp when the recurrence was created']
//   updated_at TIMESTAMP [default: `now()`, note: 'Timestamp when the recurrence was last updated']
//   Note: 'Stores recurrence patterns using cron expressions or predefined types.'
// }
// Enum RECURRENCE_TYPE {
//   "Never"
//   "Every Day"
//   "Every Week"
//   "Every 2 Weeks"
//   "Every Month"
//   "Every Year"
//   "Custom"
// }

import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';

/// The enum RecurrenceTypeEnum is used to define the type of recurrence.
enum RecurrenceTypeEnum {
  /// Represents a recurrence pattern that never repeats.
  never,

  /// Represents a recurrence pattern that repeats every day.
  everyDay,

  /// Represents a recurrence pattern that repeats every week.
  everyWeek,

  /// Represents a recurrence pattern that repeats every two weeks.
  everyTwoWeeks,

  /// Represents a recurrence pattern that repeats every month.
  everyMonth,

  /// Represents a recurrence pattern that repeats every year.
  everyYear,

  /// Represents a recurrence pattern that repeats according
  /// to a custom cron expression.
  custom;

  /// Returns the cron string representation of the recurrence type,
  /// starting from a given date.
  String? getCronString({required DateTime startDate}) {
    final minute = startDate.minute;
    final hour = startDate.hour;
    final day = startDate.day;
    final month = startDate.month;
    final weekday = startDate.weekday; // 1 = Monday, 7 = Sunday
    switch (this) {
      case RecurrenceTypeEnum.never:
        return null;
      case RecurrenceTypeEnum.everyDay:
        return '$minute $hour * * *'; // Every day at the given time
      case RecurrenceTypeEnum.everyWeek:
        return '$minute $hour * * $weekday'; // Every week on the same weekday
      case RecurrenceTypeEnum.everyTwoWeeks:
        return '$minute $hour $day/14 * *'; // Every 14 days from the start date
      case RecurrenceTypeEnum.everyMonth:
        return '$minute $hour $day * *'; // Every month on the same day
      case RecurrenceTypeEnum.everyYear:
        return '$minute $hour $day $month *'; // Every year on the same date
      case RecurrenceTypeEnum.custom:
        return null;
    }
  }
}

/// {@template recurrence_model}
/// Represents a recurrence model for scheduling tasks
/// based on cron expressions.
/// {@endtemplate}
class RecurrenceModel extends Equatable {
  /// Creates a new instance of [RecurrenceModel].
  const RecurrenceModel({
    required this.id,
    required this.cronString,
    required this.recurrenceType,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor for [RecurrenceModel] from [Recurrence]
  factory RecurrenceModel.fromRecurrence(Recurrence recurrence) {
    return RecurrenceModel(
      id: recurrence.recurrenceId,
      cronString: recurrence.recurrenceCronString,
      recurrenceType: RecurrenceTypeEnum.values.byName(
        recurrence.recurrenceRecurrenceType.name,
      ),
      description: recurrence.recurrenceDescription,
      createdAt: recurrence.recurrenceCreatedAt,
      updatedAt: recurrence.recurrenceUpdatedAt,
    );
  }

  /// Unique identifier for the recurrence model.
  final String id;

  /// Cron string representing the recurrence schedule.
  final String cronString;

  /// The type of recurrence (daily, weekly, etc.).
  final RecurrenceTypeEnum recurrenceType;

  /// A brief description of the recurrence.
  final String? description;

  /// Timestamp when the recurrence was created.
  final DateTime createdAt;

  /// Timestamp when the recurrence was last updated.
  final DateTime updatedAt;

  /// Creates a copy of this model with optional new values.
  RecurrenceModel copyWith({
    String? id,
    String? cronString,
    RecurrenceTypeEnum? recurrenceType,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurrenceModel(
      id: id ?? this.id,
      cronString: cronString ?? this.cronString,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    cronString,
    recurrenceType,
    description,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
