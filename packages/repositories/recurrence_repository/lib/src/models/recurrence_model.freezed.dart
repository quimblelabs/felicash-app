// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurrenceModel {

 String get id; String? get cronString; RecurrenceTypeEnum get recurrenceType; String? get description; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurrenceModelCopyWith<RecurrenceModel> get copyWith => _$RecurrenceModelCopyWithImpl<RecurrenceModel>(this as RecurrenceModel, _$identity);

  /// Serializes this RecurrenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurrenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.cronString, cronString) || other.cronString == cronString)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cronString,recurrenceType,description,createdAt,updatedAt);

@override
String toString() {
  return 'RecurrenceModel(id: $id, cronString: $cronString, recurrenceType: $recurrenceType, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RecurrenceModelCopyWith<$Res>  {
  factory $RecurrenceModelCopyWith(RecurrenceModel value, $Res Function(RecurrenceModel) _then) = _$RecurrenceModelCopyWithImpl;
@useResult
$Res call({
 String id, String? cronString, RecurrenceTypeEnum recurrenceType, String? description, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RecurrenceModelCopyWithImpl<$Res>
    implements $RecurrenceModelCopyWith<$Res> {
  _$RecurrenceModelCopyWithImpl(this._self, this._then);

  final RecurrenceModel _self;
  final $Res Function(RecurrenceModel) _then;

/// Create a copy of RecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cronString = freezed,Object? recurrenceType = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cronString: freezed == cronString ? _self.cronString : cronString // ignore: cast_nullable_to_non_nullable
as String?,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as RecurrenceTypeEnum,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RecurrenceModel implements RecurrenceModel {
  const _RecurrenceModel({required this.id, required this.cronString, required this.recurrenceType, required this.description, required this.createdAt, required this.updatedAt});
  factory _RecurrenceModel.fromJson(Map<String, dynamic> json) => _$RecurrenceModelFromJson(json);

@override final  String id;
@override final  String? cronString;
@override final  RecurrenceTypeEnum recurrenceType;
@override final  String? description;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurrenceModelCopyWith<_RecurrenceModel> get copyWith => __$RecurrenceModelCopyWithImpl<_RecurrenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurrenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurrenceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.cronString, cronString) || other.cronString == cronString)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cronString,recurrenceType,description,createdAt,updatedAt);

@override
String toString() {
  return 'RecurrenceModel(id: $id, cronString: $cronString, recurrenceType: $recurrenceType, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecurrenceModelCopyWith<$Res> implements $RecurrenceModelCopyWith<$Res> {
  factory _$RecurrenceModelCopyWith(_RecurrenceModel value, $Res Function(_RecurrenceModel) _then) = __$RecurrenceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? cronString, RecurrenceTypeEnum recurrenceType, String? description, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RecurrenceModelCopyWithImpl<$Res>
    implements _$RecurrenceModelCopyWith<$Res> {
  __$RecurrenceModelCopyWithImpl(this._self, this._then);

  final _RecurrenceModel _self;
  final $Res Function(_RecurrenceModel) _then;

/// Create a copy of RecurrenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cronString = freezed,Object? recurrenceType = null,Object? description = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RecurrenceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cronString: freezed == cronString ? _self.cronString : cronString // ignore: cast_nullable_to_non_nullable
as String?,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as RecurrenceTypeEnum,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
