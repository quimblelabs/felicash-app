// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_list_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionListFilter {
  String get searchKey;
  Set<CategoryModel> get categories;
  Set<TransactionTypeEnum> get types;
  Set<BaseWalletModel> get wallets;
  DateTime? get from;
  DateTime? get to;

  /// Create a copy of TransactionListFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionListFilterCopyWith<TransactionListFilter> get copyWith =>
      _$TransactionListFilterCopyWithImpl<TransactionListFilter>(
          this as TransactionListFilter, _$identity);

  /// Serializes this TransactionListFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionListFilter &&
            (identical(other.searchKey, searchKey) ||
                other.searchKey == searchKey) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality().equals(other.types, types) &&
            const DeepCollectionEquality().equals(other.wallets, wallets) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchKey,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(types),
      const DeepCollectionEquality().hash(wallets),
      from,
      to);

  @override
  String toString() {
    return 'TransactionListFilter(searchKey: $searchKey, categories: $categories, types: $types, wallets: $wallets, from: $from, to: $to)';
  }
}

/// @nodoc
abstract mixin class $TransactionListFilterCopyWith<$Res> {
  factory $TransactionListFilterCopyWith(TransactionListFilter value,
          $Res Function(TransactionListFilter) _then) =
      _$TransactionListFilterCopyWithImpl;
  @useResult
  $Res call(
      {String searchKey,
      Set<CategoryModel> categories,
      Set<TransactionTypeEnum> types,
      Set<BaseWalletModel> wallets,
      DateTime? from,
      DateTime? to});
}

/// @nodoc
class _$TransactionListFilterCopyWithImpl<$Res>
    implements $TransactionListFilterCopyWith<$Res> {
  _$TransactionListFilterCopyWithImpl(this._self, this._then);

  final TransactionListFilter _self;
  final $Res Function(TransactionListFilter) _then;

  /// Create a copy of TransactionListFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchKey = null,
    Object? categories = null,
    Object? types = null,
    Object? wallets = null,
    Object? from = freezed,
    Object? to = freezed,
  }) {
    return _then(_self.copyWith(
      searchKey: null == searchKey
          ? _self.searchKey
          : searchKey // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as Set<CategoryModel>,
      types: null == types
          ? _self.types
          : types // ignore: cast_nullable_to_non_nullable
              as Set<TransactionTypeEnum>,
      wallets: null == wallets
          ? _self.wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as Set<BaseWalletModel>,
      from: freezed == from
          ? _self.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      to: freezed == to
          ? _self.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionListFilter extends TransactionListFilter {
  const _TransactionListFilter(
      {this.searchKey = '',
      final Set<CategoryModel> categories = const {},
      final Set<TransactionTypeEnum> types = const {},
      final Set<BaseWalletModel> wallets = const {},
      this.from,
      this.to})
      : _categories = categories,
        _types = types,
        _wallets = wallets,
        super._();
  factory _TransactionListFilter.fromJson(Map<String, dynamic> json) =>
      _$TransactionListFilterFromJson(json);

  @override
  @JsonKey()
  final String searchKey;
  final Set<CategoryModel> _categories;
  @override
  @JsonKey()
  Set<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableSetView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_categories);
  }

  final Set<TransactionTypeEnum> _types;
  @override
  @JsonKey()
  Set<TransactionTypeEnum> get types {
    if (_types is EqualUnmodifiableSetView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_types);
  }

  final Set<BaseWalletModel> _wallets;
  @override
  @JsonKey()
  Set<BaseWalletModel> get wallets {
    if (_wallets is EqualUnmodifiableSetView) return _wallets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_wallets);
  }

  @override
  final DateTime? from;
  @override
  final DateTime? to;

  /// Create a copy of TransactionListFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionListFilterCopyWith<_TransactionListFilter> get copyWith =>
      __$TransactionListFilterCopyWithImpl<_TransactionListFilter>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionListFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionListFilter &&
            (identical(other.searchKey, searchKey) ||
                other.searchKey == searchKey) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            const DeepCollectionEquality().equals(other._wallets, _wallets) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchKey,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_types),
      const DeepCollectionEquality().hash(_wallets),
      from,
      to);

  @override
  String toString() {
    return 'TransactionListFilter(searchKey: $searchKey, categories: $categories, types: $types, wallets: $wallets, from: $from, to: $to)';
  }
}

/// @nodoc
abstract mixin class _$TransactionListFilterCopyWith<$Res>
    implements $TransactionListFilterCopyWith<$Res> {
  factory _$TransactionListFilterCopyWith(_TransactionListFilter value,
          $Res Function(_TransactionListFilter) _then) =
      __$TransactionListFilterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String searchKey,
      Set<CategoryModel> categories,
      Set<TransactionTypeEnum> types,
      Set<BaseWalletModel> wallets,
      DateTime? from,
      DateTime? to});
}

/// @nodoc
class __$TransactionListFilterCopyWithImpl<$Res>
    implements _$TransactionListFilterCopyWith<$Res> {
  __$TransactionListFilterCopyWithImpl(this._self, this._then);

  final _TransactionListFilter _self;
  final $Res Function(_TransactionListFilter) _then;

  /// Create a copy of TransactionListFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? searchKey = null,
    Object? categories = null,
    Object? types = null,
    Object? wallets = null,
    Object? from = freezed,
    Object? to = freezed,
  }) {
    return _then(_TransactionListFilter(
      searchKey: null == searchKey
          ? _self.searchKey
          : searchKey // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as Set<CategoryModel>,
      types: null == types
          ? _self._types
          : types // ignore: cast_nullable_to_non_nullable
              as Set<TransactionTypeEnum>,
      wallets: null == wallets
          ? _self._wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as Set<BaseWalletModel>,
      from: freezed == from
          ? _self.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      to: freezed == to
          ? _self.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
