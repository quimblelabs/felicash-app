/// Defines the frequency at which a transaction or event repeats.
enum RecurrenceType {
  /// Indicates a one-time transaction or event that does not repeat.
  never,

  /// Indicates a transaction or event that repeats every day.
  everyDay,

  /// Indicates a transaction or event that repeats every week.
  everyWeek,

  /// Indicates a transaction or event that repeats every two weeks (bi-weekly).
  every2Weeks,

  /// Indicates a transaction or event that repeats every month.
  everyMonth,

  /// Indicates a transaction or event that repeats every year.
  everyYear,

  /// Indicates a transaction or event with a custom recurrence pattern
  /// that doesn't fit the predefined intervals.
  custom,

  /// Not defined recurrence type, for unknown transactions
  unknown;

  /// Factory constructor to create a RecurrenceType from a Supabase snake_case string.
  factory RecurrenceType.fromSupabase(String direction) {
    return RecurrenceType.values.firstWhere(
      (e) => e.name.replaceAll('_', '') == direction, // Adjust for snake_case
      orElse: () => RecurrenceType.unknown,
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
