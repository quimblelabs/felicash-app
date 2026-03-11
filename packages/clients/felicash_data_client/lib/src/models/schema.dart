import 'package:powersync/powersync.dart';

/// {@template felicash_schema}
/// Schema definition for Felicash database using PowerSync
/// {@endtemplate}
const schema = Schema([
  Table(
    'budget_trackings',
    [
      Column.text('budget_tracking_transaction_id'),
      Column.text('budget_tracking_budget_id'),
      Column.real('budget_tracking_amount'),
      Column.text('budget_tracking_created_at'),
      Column.text('budget_tracking_updated_at'),
      Column.text('budget_tracking_id'),
    ],
    indexes: [
      Index('budget_tracking_budget', [
        IndexedColumn('budget_tracking_budget_id'),
      ]),
      Index('budget_tracking_transaction', [
        IndexedColumn('budget_tracking_transaction_id'),
      ]),
    ],
  ),

  Table(
    'budgets',
    [
      Column.text('budget_id'),
      Column.text('budget_user_id'),
      Column.text('budget_category_id'),
      Column.text('budget_budget_period'),
      Column.real('budget_amount'),
      Column.text('budget_start_date'),
      Column.text('budget_end_date'),
      Column.text('budget_created_at'),
      Column.text('budget_updated_at'),
    ],
    indexes: [
      Index('budget_user', [IndexedColumn('budget_user_id')]),
      Index('budget_category', [IndexedColumn('budget_category_id')]),
      Index('budget_period', [IndexedColumn('budget_budget_period')]),
    ],
  ),

  Table(
    'categories',
    [
      Column.text('category_id'),
      Column.text('category_user_id'),
      Column.text('category_parent_category_id'),
      Column.text('category_transaction_type'),
      Column.text('category_name'),
      Column.text('category_icon'),
      Column.text('category_color'),
      Column.text('category_description'),
      Column.text('category_created_at'),
      Column.text('category_updated_at'),
      Column.integer('category_enabled'),
    ],
    indexes: [
      Index('category_user', [IndexedColumn('category_user_id')]),
      Index('category_parent', [IndexedColumn('category_parent_category_id')]),
      Index('category_type', [IndexedColumn('category_transaction_type')]),
      Index('category_enabled', [IndexedColumn('category_enabled')]),
    ],
  ),

  Table(
    'credit_wallets',
    [
      Column.text('credit_wallet_wallet_id'),
      Column.real('credit_wallet_credit_limit'),
      Column.integer('credit_wallet_state_day_of_month'),
      Column.integer('credit_wallet_payment_due_day_of_month'),
      Column.text('credit_wallet_id'),
    ],
    indexes: [
      Index('credit_wallet', [IndexedColumn('credit_wallet_wallet_id')]),
    ],
  ),

  Table(
    'exchange_rates',
    [
      Column.text('exchange_rate_id'),
      Column.text('exchange_rate_from_currency'),
      Column.text('exchange_rate_to_currency'),
      Column.real('exchange_rate_rate'),
      Column.text('exchange_rate_effective_date'),
      Column.text('exchange_rate_created_at'),
      Column.text('exchange_rate_updated_at'),
    ],
    indexes: [
      Index('exchange_from_currency', [
        IndexedColumn('exchange_rate_from_currency'),
      ]),
      Index('exchange_to_currency', [
        IndexedColumn('exchange_rate_to_currency'),
      ]),
      Index('exchange_effective_date', [
        IndexedColumn('exchange_rate_effective_date'),
      ]),
    ],
  ),

  Table(
    'lending_borrowing_transactions',
    [
      Column.text('lending_borrowing_transaction_transaction_id'),
      Column.text('lending_borrowing_transaction_counter_party_id'),
      Column.text('lending_borrowing_transaction_counter_party_name'),
      Column.real('lending_borrowing_transaction_payback_amount'),
      Column.text('lending_borrowing_transaction_id'),
    ],
    indexes: [
      Index('lending_transaction', [
        IndexedColumn('lending_borrowing_transaction_transaction_id'),
      ]),
      Index('lending_counter_party', [
        IndexedColumn('lending_borrowing_transaction_counter_party_id'),
      ]),
    ],
  ),

  Table(
    'merchants',
    [
      Column.text('merchant_id'),
      Column.text('merchant_name'),
      Column.text('merchant_address'),
      Column.real('merchant_lat'),
      Column.real('merchant_lng'),
      Column.text('merchant_metadata'),
      Column.text('merchant_created_at'),
      Column.text('merchant_updated_at'),
      Column.text('merchant_user_id'),
    ],
    indexes: [
      Index('merchant_user', [IndexedColumn('merchant_user_id')]),
      Index('merchant_name_idx', [IndexedColumn('merchant_name')]),
    ],
  ),

  Table(
    'payback_links',
    [
      Column.text('payback_link_id'),
      Column.text('payback_link_original_transaction_id'),
      Column.text('payback_link_payback_transaction_id'),
      Column.text('payback_link_created_at'),
    ],
    indexes: [
      Index('payback_original', [
        IndexedColumn('payback_link_original_transaction_id'),
      ]),
      Index('payback_transaction', [
        IndexedColumn('payback_link_payback_transaction_id'),
      ]),
    ],
  ),

  Table(
    'profiles',
    [Column.text('profile_id'), Column.text('profile_fcm_token')],
    indexes: [
      Index('profile_id_idx', [IndexedColumn('profile_id')]),
    ],
  ),

  Table(
    'recurrences',
    [
      Column.text('recurrence_id'),
      Column.text('recurrence_user_id'),
      Column.text('recurrence_cron_string'),
      Column.text('recurrence_recurrence_type'),
      Column.text('recurrence_description'),
      Column.text('recurrence_created_at'),
      Column.text('recurrence_updated_at'),
    ],
    indexes: [
      Index('recurrence_user', [IndexedColumn('recurrence_user_id')]),
      Index('recurrence_type', [IndexedColumn('recurrence_recurrence_type')]),
    ],
  ),

  Table(
    'savings_wallets',
    [
      Column.text('savings_wallet_wallet_id'),
      Column.real('savings_wallet_savings_goal'),
      Column.text('savings_wallet_id'),
    ],
    indexes: [
      Index('savings_wallet', [IndexedColumn('savings_wallet_wallet_id')]),
    ],
  ),

  Table(
    'transactions',
    [
      Column.text('transaction_id'),
      Column.text('transaction_user_id'),
      Column.text('transaction_wallet_id'),
      Column.text('transaction_category_id'),
      Column.text('transaction_transaction_type'),
      Column.real('transaction_amount'),
      Column.text('transaction_transaction_date'),
      Column.text('transaction_notes'),
      Column.text('transaction_image_attachment'),
      Column.text('transaction_recurrence_id'),
      Column.text('transaction_transfer_id'),
      Column.text('transaction_created_at'),
      Column.text('transaction_updated_at'),
      Column.text('transaction_merchant_id'),
    ],
    indexes: [
      Index('transaction_user', [IndexedColumn('transaction_user_id')]),
      Index('transaction_wallet', [IndexedColumn('transaction_wallet_id')]),
      Index('transaction_category', [IndexedColumn('transaction_category_id')]),
      Index('transaction_type', [
        IndexedColumn('transaction_transaction_type'),
      ]),
      Index('transaction_date', [
        IndexedColumn('transaction_transaction_date'),
      ]),
      Index('transaction_merchant', [IndexedColumn('transaction_merchant_id')]),
      Index('transaction_recurrence', [
        IndexedColumn('transaction_recurrence_id'),
      ]),
    ],
  ),

  Table(
    'user_settings',
    [
      Column.text('user_setting_id'),
      Column.text('user_setting_base_currency_code'),
      Column.text('user_setting_language_code'),
      Column.text('user_setting_date_format'),
      Column.text('user_setting_default_wallet'),
      Column.text('user_setting_created_at'),
      Column.text('user_setting_updated_at'),
      Column.text('user_setting_theme'),
      Column.text('user_setting_monetary_format'),
      Column.text('user_setting_user_id'),
    ],
    indexes: [
      Index('user_setting_user', [IndexedColumn('user_setting_user_id')]),
    ],
  ),

  Table(
    'wallets',
    [
      Column.text('wallet_id'),
      Column.text('wallet_user_id'),
      Column.text('wallet_name'),
      Column.text('wallet_description'),
      Column.text('wallet_currency_code'),
      Column.real('wallet_balance'),
      Column.text('wallet_created_at'),
      Column.text('wallet_updated_at'),
      Column.integer('wallet_exclude_from_total'),
      Column.integer('wallet_archived'),
      Column.text('wallet_archived_at'),
      Column.text('wallet_archive_reason'),
      Column.text('wallet_wallet_type'),
      Column.text('wallet_icon'),
      Column.text('wallet_color'),
    ],
    indexes: [
      Index('wallet_user', [IndexedColumn('wallet_user_id')]),
      Index('wallet_currency', [IndexedColumn('wallet_currency_code')]),
      Index('wallet_type', [IndexedColumn('wallet_wallet_type')]),
      Index('wallet_archived_idx', [IndexedColumn('wallet_archived')]),
    ],
  ),
]);
