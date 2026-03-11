import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurrence_model.freezed.dart';
part 'recurrence_model.g.dart';

/// {@template recurrence_model}
/// Represents a recurrence model for scheduling tasks
/// based on cron expressions.
/// {@endtemplate}
@freezed
abstract class RecurrenceModel with _$RecurrenceModel {
  /// Creates a new instance of [RecurrenceModel].
  const factory RecurrenceModel({
    required String id,
    required String? cronString,
    required RecurrenceTypeEnum recurrenceType,
    required String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RecurrenceModel;

  factory RecurrenceModel.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceModelFromJson(json);

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
}

/// The enum RecurrenceTypeEnum is used to define the type of recurrence.
enum RecurrenceTypeEnum {
  /// Represents a recurrence pattern that never repeats.
  @JsonValue('never')
  never,

  /// Represents a recurrence pattern that repeats every day.
  @JsonValue('every_day')
  everyDay,

  /// Represents a recurrence pattern that repeats every week.
  @JsonValue('every_week')
  everyWeek,

  /// Represents a recurrence pattern that repeats every two weeks.
  @JsonValue('every_two_weeks')
  everyTwoWeeks,

  /// Represents a recurrence pattern that repeats every month.
  @JsonValue('every_month')
  everyMonth,

  /// Represents a recurrence pattern that repeats every year.
  @JsonValue('every_year')
  everyYear,

  /// Represents a recurrence pattern that repeats according
  /// to a custom cron expression.
  @JsonValue('custom')
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
