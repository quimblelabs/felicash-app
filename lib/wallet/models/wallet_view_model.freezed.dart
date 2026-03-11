// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletViewModel {
  BaseWalletModel get wallet;
  CurrencyModel get currency;

  /// Create a copy of WalletViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletViewModelCopyWith<WalletViewModel> get copyWith =>
      _$WalletViewModelCopyWithImpl<WalletViewModel>(
          this as WalletViewModel, _$identity);

  /// Serializes this WalletViewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletViewModel &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wallet, currency);

  @override
  String toString() {
    return 'WalletViewModel(wallet: $wallet, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class $WalletViewModelCopyWith<$Res> {
  factory $WalletViewModelCopyWith(
          WalletViewModel value, $Res Function(WalletViewModel) _then) =
      _$WalletViewModelCopyWithImpl;
  @useResult
  $Res call({BaseWalletModel wallet, CurrencyModel currency});
}

/// @nodoc
class _$WalletViewModelCopyWithImpl<$Res>
    implements $WalletViewModelCopyWith<$Res> {
  _$WalletViewModelCopyWithImpl(this._self, this._then);

  final WalletViewModel _self;
  final $Res Function(WalletViewModel) _then;

  /// Create a copy of WalletViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wallet = null,
    Object? currency = null,
  }) {
    return _then(_self.copyWith(
      wallet: null == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WalletViewModel implements WalletViewModel {
  const _WalletViewModel({required this.wallet, required this.currency});
  factory _WalletViewModel.fromJson(Map<String, dynamic> json) =>
      _$WalletViewModelFromJson(json);

  @override
  final BaseWalletModel wallet;
  @override
  final CurrencyModel currency;

  /// Create a copy of WalletViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalletViewModelCopyWith<_WalletViewModel> get copyWith =>
      __$WalletViewModelCopyWithImpl<_WalletViewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalletViewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletViewModel &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wallet, currency);

  @override
  String toString() {
    return 'WalletViewModel(wallet: $wallet, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class _$WalletViewModelCopyWith<$Res>
    implements $WalletViewModelCopyWith<$Res> {
  factory _$WalletViewModelCopyWith(
          _WalletViewModel value, $Res Function(_WalletViewModel) _then) =
      __$WalletViewModelCopyWithImpl;
  @override
  @useResult
  $Res call({BaseWalletModel wallet, CurrencyModel currency});
}

/// @nodoc
class __$WalletViewModelCopyWithImpl<$Res>
    implements _$WalletViewModelCopyWith<$Res> {
  __$WalletViewModelCopyWithImpl(this._self, this._then);

  final _WalletViewModel _self;
  final $Res Function(_WalletViewModel) _then;

  /// Create a copy of WalletViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? wallet = null,
    Object? currency = null,
  }) {
    return _then(_WalletViewModel(
      wallet: null == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as BaseWalletModel,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyModel,
    ));
  }
}

// dart format on
