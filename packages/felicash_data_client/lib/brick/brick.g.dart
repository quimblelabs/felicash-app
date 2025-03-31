// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:equatable/equatable.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/enums/wallet_type.enum.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/profile.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/uuid.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/wallet.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/enums/budget_period.enum.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/category.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/budget.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/transaction.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/enums/transaction_type.enum.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/enums/recurrence_type.enum.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/merchant.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:felicash_data_client/src/models/recurrence.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../src/models/wallet.model.dart';
import '../src/models/credit_wallet.model.dart';
import '../src/models/budget.model.dart';
import '../src/models/budget_tracking.model.dart';
import '../src/models/category.model.dart';
import '../src/models/currency.model.dart';
import '../src/models/exchange_rate.model.dart';
import '../src/models/lending_borrowing_transaction.model.dart';
import '../src/models/merchant.model.dart';
import '../src/models/payback_link.model.dart';
import '../src/models/profile.model.dart';
import '../src/models/recurrence.model.dart';
import '../src/models/saving_wallet.model.dart';
import '../src/models/transaction.model.dart';

part 'adapters/wallet_adapter.g.dart';
part 'adapters/credit_wallet_adapter.g.dart';
part 'adapters/budget_adapter.g.dart';
part 'adapters/budget_tracking_adapter.g.dart';
part 'adapters/category_adapter.g.dart';
part 'adapters/currency_adapter.g.dart';
part 'adapters/exchange_rate_adapter.g.dart';
part 'adapters/lending_borrowing_transaction_adapter.g.dart';
part 'adapters/merchant_adapter.g.dart';
part 'adapters/payback_link_adapter.g.dart';
part 'adapters/profile_adapter.g.dart';
part 'adapters/recurrence_adapter.g.dart';
part 'adapters/savings_wallet_adapter.g.dart';
part 'adapters/transaction_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  Wallet: WalletAdapter(),
  CreditWallet: CreditWalletAdapter(),
  Budget: BudgetAdapter(),
  BudgetTracking: BudgetTrackingAdapter(),
  Category: CategoryAdapter(),
  Currency: CurrencyAdapter(),
  ExchangeRate: ExchangeRateAdapter(),
  LendingBorrowingTransaction: LendingBorrowingTransactionAdapter(),
  Merchant: MerchantAdapter(),
  PaybackLink: PaybackLinkAdapter(),
  Profile: ProfileAdapter(),
  Recurrence: RecurrenceAdapter(),
  SavingsWallet: SavingsWalletAdapter(),
  Transaction: TransactionAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  Wallet: WalletAdapter(),
  CreditWallet: CreditWalletAdapter(),
  Budget: BudgetAdapter(),
  BudgetTracking: BudgetTrackingAdapter(),
  Category: CategoryAdapter(),
  Currency: CurrencyAdapter(),
  ExchangeRate: ExchangeRateAdapter(),
  LendingBorrowingTransaction: LendingBorrowingTransactionAdapter(),
  Merchant: MerchantAdapter(),
  PaybackLink: PaybackLinkAdapter(),
  Profile: ProfileAdapter(),
  Recurrence: RecurrenceAdapter(),
  SavingsWallet: SavingsWalletAdapter(),
  Transaction: TransactionAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
