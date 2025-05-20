// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {
  String get id;
  BaseWalletModel get wallet;
  TransactionTypeEnum get transactionType;
  double get amount;
  DateTime get transactionDate;
  DateTime get createdAt;
  DateTime get updatedAt;
  CategoryModel? get category;
  String? get notes;
  String? get imageAttachment;
  RecurrenceModel? get recurrence;
  BaseWalletModel? get transferWallet;
  TransactionModel? get transferTransaction;
  String? get merchantId;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      _$TransactionModelCopyWithImpl<TransactionModel>(
          this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.imageAttachment, imageAttachment) ||
                other.imageAttachment == imageAttachment) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.transferWallet, transferWallet) ||
                other.transferWallet == transferWallet) &&
            (identical(other.transferTransaction, transferTransaction) ||
                other.transferTransaction == transferTransaction) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      wallet,
      transactionType,
      amount,
      transactionDate,
      createdAt,
      updatedAt,
      category,
      notes,
      imageAttachment,
      recurrence,
      transferWallet,
      transferTransaction,
      merchantId);

  @override
  String toString() {
    return 'TransactionModel(id: $id, wallet: $wallet, transactionType: $transactionType, amount: $amount, transactionDate: $transactionDate, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, notes: $notes, imageAttachment: $imageAttachment, recurrence: $recurrence, transferWallet: $transferWallet, transferTransaction: $transferTransaction, merchantId: $merchantId)';
  }
}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) _then) =
      _$TransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      BaseWalletModel wallet,
      TransactionTypeEnum transactionType,
      double amount,
      DateTime transactionDate,
      DateTime createdAt,
      DateTime updatedAt,
      CategoryModel? category,
      String? notes,
      String? imageAttachment,
      RecurrenceModel? recurrence,
      BaseWalletModel? transferWallet,
      TransactionModel? transferTransaction,
      String? merchantId});

  $RecurrenceModelCopyWith<$Res>? get recurrence;
  $TransactionModelCopyWith<$Res>? get transferTransaction;
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? wallet = null,
    Object? transactionType = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
    Object? notes = freezed,
    Object? imageAttachment = freezed,
    Object? recurrence = freezed,
    Object? transferWallet = freezed,
    Object? transferTransaction = freezed,
    Object? merchantId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel,
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionTypeEnum,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageAttachment: freezed == imageAttachment
          ? _self.imageAttachment
          : imageAttachment // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrence: freezed == recurrence
          ? _self.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceModel?,
      transferWallet: freezed == transferWallet
          ? _self.transferWallet
          : transferWallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel?,
      transferTransaction: freezed == transferTransaction
          ? _self.transferTransaction
          : transferTransaction // ignore: cast_nullable_to_non_nullable
              as TransactionModel?,
      merchantId: freezed == merchantId
          ? _self.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
      return null;
    }

    return $RecurrenceModelCopyWith<$Res>(_self.recurrence!, (value) {
      return _then(_self.copyWith(recurrence: value));
    });
  }

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<$Res>? get transferTransaction {
    if (_self.transferTransaction == null) {
      return null;
    }

    return $TransactionModelCopyWith<$Res>(_self.transferTransaction!, (value) {
      return _then(_self.copyWith(transferTransaction: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionModel implements TransactionModel {
  _TransactionModel(
      {required this.id,
      required this.wallet,
      required this.transactionType,
      required this.amount,
      required this.transactionDate,
      required this.createdAt,
      required this.updatedAt,
      this.category,
      this.notes,
      this.imageAttachment,
      this.recurrence,
      this.transferWallet,
      this.transferTransaction,
      this.merchantId});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  final String id;
  @override
  final BaseWalletModel wallet;
  @override
  final TransactionTypeEnum transactionType;
  @override
  final double amount;
  @override
  final DateTime transactionDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final CategoryModel? category;
  @override
  final String? notes;
  @override
  final String? imageAttachment;
  @override
  final RecurrenceModel? recurrence;
  @override
  final BaseWalletModel? transferWallet;
  @override
  final TransactionModel? transferTransaction;
  @override
  final String? merchantId;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionModelCopyWith<_TransactionModel> get copyWith =>
      __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.imageAttachment, imageAttachment) ||
                other.imageAttachment == imageAttachment) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.transferWallet, transferWallet) ||
                other.transferWallet == transferWallet) &&
            (identical(other.transferTransaction, transferTransaction) ||
                other.transferTransaction == transferTransaction) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      wallet,
      transactionType,
      amount,
      transactionDate,
      createdAt,
      updatedAt,
      category,
      notes,
      imageAttachment,
      recurrence,
      transferWallet,
      transferTransaction,
      merchantId);

  @override
  String toString() {
    return 'TransactionModel(id: $id, wallet: $wallet, transactionType: $transactionType, amount: $amount, transactionDate: $transactionDate, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, notes: $notes, imageAttachment: $imageAttachment, recurrence: $recurrence, transferWallet: $transferWallet, transferTransaction: $transferTransaction, merchantId: $merchantId)';
  }
}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(
          _TransactionModel value, $Res Function(_TransactionModel) _then) =
      __$TransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      BaseWalletModel wallet,
      TransactionTypeEnum transactionType,
      double amount,
      DateTime transactionDate,
      DateTime createdAt,
      DateTime updatedAt,
      CategoryModel? category,
      String? notes,
      String? imageAttachment,
      RecurrenceModel? recurrence,
      BaseWalletModel? transferWallet,
      TransactionModel? transferTransaction,
      String? merchantId});

  @override
  $RecurrenceModelCopyWith<$Res>? get recurrence;
  @override
  $TransactionModelCopyWith<$Res>? get transferTransaction;
}

/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? wallet = null,
    Object? transactionType = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
    Object? notes = freezed,
    Object? imageAttachment = freezed,
    Object? recurrence = freezed,
    Object? transferWallet = freezed,
    Object? transferTransaction = freezed,
    Object? merchantId = freezed,
  }) {
    return _then(_TransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel,
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionTypeEnum,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageAttachment: freezed == imageAttachment
          ? _self.imageAttachment
          : imageAttachment // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrence: freezed == recurrence
          ? _self.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceModel?,
      transferWallet: freezed == transferWallet
          ? _self.transferWallet
          : transferWallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel?,
      transferTransaction: freezed == transferTransaction
          ? _self.transferTransaction
          : transferTransaction // ignore: cast_nullable_to_non_nullable
              as TransactionModel?,
      merchantId: freezed == merchantId
          ? _self.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
      return null;
    }

    return $RecurrenceModelCopyWith<$Res>(_self.recurrence!, (value) {
      return _then(_self.copyWith(recurrence: value));
    });
  }

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<$Res>? get transferTransaction {
    if (_self.transferTransaction == null) {
      return null;
    }

    return $TransactionModelCopyWith<$Res>(_self.transferTransaction!, (value) {
      return _then(_self.copyWith(transferTransaction: value));
    });
  }
}

// dart format on
