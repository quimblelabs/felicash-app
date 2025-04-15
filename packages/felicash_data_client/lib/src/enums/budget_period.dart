/// {@template budget_period}
/// Enum representing the different budget periods.
///
/// - `daily`: A daily budget period.
/// - `weekly`: A weekly budget period.
/// - `monthly`: A monthly budget period.
/// - `quarterly`: A quarterly budget period.
/// - `yearly`: A yearly budget period.
/// {@endtemplate}
enum BudgetPeriod {
  /// A daily budget period.
  daily,

  /// A weekly budget period.
  weekly,

  /// A monthly budget period.
  monthly,

  /// A quarterly budget period.
  quarterly,

  /// A yearly budget period.
  yearly,

  /// Not defined budget period.
  unknown;

  /// Factory constructor to create a BudgetPeriod from a Supabase snake_case string.
  factory BudgetPeriod.fromSupabase(String direction) {
    return BudgetPeriod.values.firstWhere(
      (e) => e.name.replaceAll('_', '') == direction, // Adjust for snake_case
      orElse: () => BudgetPeriod.unknown,
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
