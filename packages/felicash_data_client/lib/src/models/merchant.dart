import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/profile.dart';
import 'package:felicash_data_client/src/typedefs/typedef.dart';
import 'package:json_annotation/json_annotation.dart';
part 'merchant.g.dart';

/// {@template merchant_fields}
/// Merchant fields
/// {@endtemplate}
typedef MerchantFields = _$MerchantJsonKeys;

/// {@template savings_wallet_model}
/// Profile model
/// {@endtemplate}
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createJsonKeys: true,
  createFactory: false,
  createToJson: false,
)
class Merchant {
  /// {@macro profile_model}
  const Merchant({
    required this.merchantId,
    required this.merchantName,
    required this.merchantCreatedAt,
    required this.merchantUpdatedAt,
    this.merchantAddress,
    this.merchantLat,
    this.merchantLng,
    this.merchantMetadata,
    this.profiles = const [],
  }) : id = merchantId;

  /// Factory constructor for [Merchant] from [SqliteRow]
  factory Merchant.fromRow(SqliteRow row) {
    return Merchant(
      merchantId: row[MerchantFields.merchantId] as String,
      merchantName: row[MerchantFields.merchantName] as String,
      merchantAddress: row[MerchantFields.merchantAddress] as String?,
      merchantLat: row[MerchantFields.merchantLat] as double?,
      merchantLng: row[MerchantFields.merchantLng] as double?,
      merchantMetadata:
          row[MerchantFields.merchantMetadata] as Map<String, dynamic>?,
      merchantCreatedAt: DateTime.parse(
        row[MerchantFields.merchantCreatedAt] as String,
      ),
      merchantUpdatedAt: DateTime.parse(
        row[MerchantFields.merchantUpdatedAt] as String,
      ),
      profiles: [],
    );
  }

  /// Id field to suitable with sqlite database
  final String id;

  /// Id of the merchant
  final String merchantId;

  /// Name of the merchant
  final String merchantName;

  /// Address of the merchant
  final String? merchantAddress;

  /// Lat of the merchant
  final double? merchantLat;

  /// Lng of the merchant
  final double? merchantLng;

  /// Metadata of the merchant
  final Map<String, dynamic>? merchantMetadata;

  /// Created at of the merchant
  final DateTime merchantCreatedAt;

  /// Updated at of the merchant
  final DateTime merchantUpdatedAt;

  /// Profile of the merchant
  final List<Profile> profiles;

  /// Returns a copy of the [Merchant] with the given fields replaced.
  Merchant copyWith({
    String? merchantId,
    String? merchantName,
    String? merchantAddress,
    double? merchantLat,
    double? merchantLng,
    Map<String, dynamic>? merchantMetadata,
    DateTime? merchantCreatedAt,
    DateTime? merchantUpdatedAt,
    List<Profile>? profiles,
  }) {
    return Merchant(
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantLat: merchantLat ?? this.merchantLat,
      merchantLng: merchantLng ?? this.merchantLng,
      merchantMetadata: merchantMetadata ?? this.merchantMetadata,
      merchantCreatedAt: merchantCreatedAt ?? this.merchantCreatedAt,
      merchantUpdatedAt: merchantUpdatedAt ?? this.merchantUpdatedAt,
      profiles: profiles ?? this.profiles,
    );
  }
}
