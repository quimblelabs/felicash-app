/// Enum for wallet types.
library;
// ignore_for_file: sort_constructors_first

enum WalletType {
  /// Basic wallet, for general use
  basic._('basic'),

  /// Credit card wallet, for credit card payments or account payments that
  /// have a credit limit
  credit._('credit'),

  /// Savings wallet, for savings accounts
  savings._('savings'),

  /// Not defined wallet, for unknown wallets
  unknown._('unknown');

  /// The json key of the enum
  final String jsonKey;

  /// Private constructor to create a WalletType.
  const WalletType._(this.jsonKey);

  /// Factory constructor to create a WalletType from a Supabase snake_case string.
  factory WalletType.fromSupabase(String direction) {
    return WalletType.values.firstWhere(
      (e) => e.name.replaceAll('_', '') == direction, // Adjust for snake_case
      orElse: () => WalletType.unknown,
    );
  }

  /// Convert to Supabase snake_case value.
  String toSupabase() {
    return name
        .replaceAllMapped(
          RegExp('([a-z])([A-Z])'),
          (Match m) => '${m[1]}_${m[2]?.toLowerCase()}',
        )
        .toLowerCase(); // Convert camelCase to snake_case
  }
}
