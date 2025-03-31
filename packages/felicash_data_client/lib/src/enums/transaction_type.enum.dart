/// Enum representing different types of financial transactions.
enum TransactionType {
  /// Represents an expense transaction type.
  ///
  /// This type is used for transactions that involve spending money,
  /// such as purchases, bills, and other costs incurred.
  expense,

  /// Represents an income transaction type.
  ///
  /// This type is used for transactions that involve earning money,
  /// including salaries, bonuses, interest earned, and any other sources of revenue.
  income,

  /// Represents a lending transaction type.
  ///
  /// This type is used when money is given to another party with the expectation of repayment.
  /// It records the amount lent and details of the borrower.
  lending,

  /// Represents a borrowing transaction type.
  ///
  /// This type is used when money is received from another party with the obligation to repay.
  /// It tracks the amount borrowed and the lender's details.
  borrowing,

  /// Represents a transfer transaction type.
  ///
  /// This type is used for transactions that involve transferring money
  /// between accounts or individuals. It does not imply income or expense,
  /// but rather a movement of funds.
  transfer,

  /// Represents a repayment transaction type.
  ///
  /// This type is used for transactions that involve paying back borrowed money.
  /// It records the amount repaid and reduces the outstanding debt.
  rePayment,

  /// Represents a debt collecting transaction type.
  ///
  /// This type is used for transactions that involve collecting owed money from others.
  /// It tracks the amounts collected and the details of the debtor.
  debtCollecting,

  /// Not defined transaction type, for unknown transactions
  ///
  /// This type is used for transactions that are not defined or unknown.
  unknown;

  /// Factory constructor to create a TransactionType from a Supabase snake_case string.
  factory TransactionType.fromSupabase(String direction) {
    return TransactionType.values.firstWhere(
      (e) => e.name.replaceAll('_', '') == direction, // Adjust for snake_case
      orElse: () => TransactionType.unknown,
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
