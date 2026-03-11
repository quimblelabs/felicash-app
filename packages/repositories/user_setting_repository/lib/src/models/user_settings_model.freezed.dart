// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettingsModel {
  String? get id;
  String get theme;
  String get language;
  String? get defaultWalletId;
  String? get currency;
  String get txDateFormat;
  String get monetaryFormat;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSettingsModelCopyWith<UserSettingsModel> get copyWith =>
      _$UserSettingsModelCopyWithImpl<UserSettingsModel>(
          this as UserSettingsModel, _$identity);

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSettingsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.defaultWalletId, defaultWalletId) ||
                other.defaultWalletId == defaultWalletId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.txDateFormat, txDateFormat) ||
                other.txDateFormat == txDateFormat) &&
            (identical(other.monetaryFormat, monetaryFormat) ||
                other.monetaryFormat == monetaryFormat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, theme, language,
      defaultWalletId, currency, txDateFormat, monetaryFormat);

  @override
  String toString() {
    return 'UserSettingsModel(id: $id, theme: $theme, language: $language, defaultWalletId: $defaultWalletId, currency: $currency, txDateFormat: $txDateFormat, monetaryFormat: $monetaryFormat)';
  }
}

/// @nodoc
abstract mixin class $UserSettingsModelCopyWith<$Res> {
  factory $UserSettingsModelCopyWith(
          UserSettingsModel value, $Res Function(UserSettingsModel) _then) =
      _$UserSettingsModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String theme,
      String language,
      String? defaultWalletId,
      String? currency,
      String txDateFormat,
      String monetaryFormat});
}

/// @nodoc
class _$UserSettingsModelCopyWithImpl<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  _$UserSettingsModelCopyWithImpl(this._self, this._then);

  final UserSettingsModel _self;
  final $Res Function(UserSettingsModel) _then;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? theme = null,
    Object? language = null,
    Object? defaultWalletId = freezed,
    Object? currency = freezed,
    Object? txDateFormat = null,
    Object? monetaryFormat = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      defaultWalletId: freezed == defaultWalletId
          ? _self.defaultWalletId
          : defaultWalletId // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      txDateFormat: null == txDateFormat
          ? _self.txDateFormat
          : txDateFormat // ignore: cast_nullable_to_non_nullable
              as String,
      monetaryFormat: null == monetaryFormat
          ? _self.monetaryFormat
          : monetaryFormat // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserSettingsModel implements UserSettingsModel {
  const _UserSettingsModel(
      {this.id,
      this.theme = 'system',
      this.language = 'en',
      this.defaultWalletId,
      this.currency,
      this.txDateFormat = 'system',
      this.monetaryFormat = 'system'});
  factory _UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final String language;
  @override
  final String? defaultWalletId;
  @override
  final String? currency;
  @override
  @JsonKey()
  final String txDateFormat;
  @override
  @JsonKey()
  final String monetaryFormat;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSettingsModelCopyWith<_UserSettingsModel> get copyWith =>
      __$UserSettingsModelCopyWithImpl<_UserSettingsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSettingsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSettingsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.defaultWalletId, defaultWalletId) ||
                other.defaultWalletId == defaultWalletId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.txDateFormat, txDateFormat) ||
                other.txDateFormat == txDateFormat) &&
            (identical(other.monetaryFormat, monetaryFormat) ||
                other.monetaryFormat == monetaryFormat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, theme, language,
      defaultWalletId, currency, txDateFormat, monetaryFormat);

  @override
  String toString() {
    return 'UserSettingsModel(id: $id, theme: $theme, language: $language, defaultWalletId: $defaultWalletId, currency: $currency, txDateFormat: $txDateFormat, monetaryFormat: $monetaryFormat)';
  }
}

/// @nodoc
abstract mixin class _$UserSettingsModelCopyWith<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  factory _$UserSettingsModelCopyWith(
          _UserSettingsModel value, $Res Function(_UserSettingsModel) _then) =
      __$UserSettingsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String theme,
      String language,
      String? defaultWalletId,
      String? currency,
      String txDateFormat,
      String monetaryFormat});
}

/// @nodoc
class __$UserSettingsModelCopyWithImpl<$Res>
    implements _$UserSettingsModelCopyWith<$Res> {
  __$UserSettingsModelCopyWithImpl(this._self, this._then);

  final _UserSettingsModel _self;
  final $Res Function(_UserSettingsModel) _then;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? theme = null,
    Object? language = null,
    Object? defaultWalletId = freezed,
    Object? currency = freezed,
    Object? txDateFormat = null,
    Object? monetaryFormat = null,
  }) {
    return _then(_UserSettingsModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      defaultWalletId: freezed == defaultWalletId
          ? _self.defaultWalletId
          : defaultWalletId // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      txDateFormat: null == txDateFormat
          ? _self.txDateFormat
          : txDateFormat // ignore: cast_nullable_to_non_nullable
              as String,
      monetaryFormat: null == monetaryFormat
          ? _self.monetaryFormat
          : monetaryFormat // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
