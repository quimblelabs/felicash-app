/// Enum for wallet types.
enum WalletType {
  /// Basic wallet, for general use
  basic,

  /// Credit card wallet, for credit card payments or account payments that
  /// have a credit limit
  credit,

  /// Savings wallet, for savings accounts
  savings,

  /// Not defined wallet, for unknown wallets
  unknown;

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
