// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurrenceModel _$RecurrenceModelFromJson(Map<String, dynamic> json) =>
    _RecurrenceModel(
      id: json['id'] as String,
      cronString: json['cronString'] as String?,
      recurrenceType: $enumDecode(
        _$RecurrenceTypeEnumEnumMap,
        json['recurrenceType'],
      ),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecurrenceModelToJson(_RecurrenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cronString': instance.cronString,
      'recurrenceType': _$RecurrenceTypeEnumEnumMap[instance.recurrenceType]!,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$RecurrenceTypeEnumEnumMap = {
  RecurrenceTypeEnum.never: 'never',
  RecurrenceTypeEnum.everyDay: 'every_day',
  RecurrenceTypeEnum.everyWeek: 'every_week',
  RecurrenceTypeEnum.everyTwoWeeks: 'every_two_weeks',
  RecurrenceTypeEnum.everyMonth: 'every_month',
  RecurrenceTypeEnum.everyYear: 'every_year',
  RecurrenceTypeEnum.custom: 'custom',
};
