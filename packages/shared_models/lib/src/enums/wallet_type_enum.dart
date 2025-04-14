/// Wallet type enum
enum WalletTypeEnum {
  /// Basic wallet type
  basic._('basic'),

  /// Credit wallet type
  credit._('credit'),

  /// Savings wallet type
  savings._('savings');

  /// The json key of the enum
  final String jsonKey;

  // ignore: sort_constructors_first
  const WalletTypeEnum._(this.jsonKey);
}
