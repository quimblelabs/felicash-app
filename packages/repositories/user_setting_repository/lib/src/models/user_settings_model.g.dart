// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    _UserSettingsModel(
      id: json['id'] as String?,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      defaultWalletId: json['defaultWalletId'] as String?,
      currency: json['currency'] as String?,
      txDateFormat: json['txDateFormat'] as String? ?? 'system',
      monetaryFormat: json['monetaryFormat'] as String? ?? 'system',
    );

Map<String, dynamic> _$UserSettingsModelToJson(_UserSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
      'language': instance.language,
      'defaultWalletId': instance.defaultWalletId,
      'currency': instance.currency,
      'txDateFormat': instance.txDateFormat,
      'monetaryFormat': instance.monetaryFormat,
    };
