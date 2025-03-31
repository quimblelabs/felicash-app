// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250329202901.migration.dart';
part '20250329203122.migration.dart';
part '20250329203136.migration.dart';
part '20250329203143.migration.dart';
part '20250329203217.migration.dart';
part '20250329203259.migration.dart';
part '20250330113225.migration.dart';
part '20250330113540.migration.dart';
part '20250330113604.migration.dart';
part '20250330114131.migration.dart';
part '20250330114233.migration.dart';
part '20250330114404.migration.dart';
part '20250330115208.migration.dart';
part '20250330120543.migration.dart';
part '20250330120613.migration.dart';
part '20250330155844.migration.dart';
part '20250330160000.migration.dart';
part '20250330160038.migration.dart';
part '20250330160059.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250329202901(),
  const Migration20250329203122(),
  const Migration20250329203136(),
  const Migration20250329203143(),
  const Migration20250329203217(),
  const Migration20250329203259(),
  const Migration20250330113225(),
  const Migration20250330113540(),
  const Migration20250330113604(),
  const Migration20250330114131(),
  const Migration20250330114233(),
  const Migration20250330114404(),
  const Migration20250330115208(),
  const Migration20250330120543(),
  const Migration20250330120613(),
  const Migration20250330155844(),
  const Migration20250330160000(),
  const Migration20250330160038(),
  const Migration20250330160059(),
};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  20250330160059,
  generatorVersion: 1,
  tables: <SchemaTable>{
    SchemaTable(
      'Wallet',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('wallet_type', Column.integer),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('description', Column.varchar),
        SchemaColumn('base_currency', Column.varchar),
        SchemaColumn('balance', Column.Double),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('exclude_from_total', Column.boolean),
        SchemaColumn('archived', Column.boolean),
        SchemaColumn('archived_at', Column.datetime),
        SchemaColumn('archive_reason', Column.varchar),
        SchemaColumn('user_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'CreditWallet',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn(
          'wallet_Wallet_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Wallet',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('credit_limit', Column.Double),
        SchemaColumn('state_day_of_month', Column.integer),
        SchemaColumn('payment_due_day_of_month', Column.integer),
        SchemaColumn('wallet_id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['wallet_id'], unique: true),
      },
    ),
    SchemaTable(
      'Budget',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'category_Category_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Category',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('period', Column.integer),
        SchemaColumn('amount', Column.Double),
        SchemaColumn('start_date', Column.datetime),
        SchemaColumn('end_date', Column.datetime),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('user_id', Column.varchar),
        SchemaColumn('category_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'BudgetTracking',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn(
          'transaction_Transaction_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Transaction',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'budget_Budget_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Budget',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('amount', Column.Double),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('transaction_id', Column.varchar),
        SchemaColumn('budget_id', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'Category',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('parent_category_id', Column.varchar),
        SchemaColumn('transaction_type', Column.integer),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('icon', Column.varchar),
        SchemaColumn('color', Column.varchar),
        SchemaColumn('description', Column.varchar),
        SchemaColumn('enabled', Column.boolean),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('user_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Currency',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('code', Column.varchar, unique: true),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('symbol', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['code'], unique: true),
      },
    ),
    SchemaTable(
      'ExchangeRate',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn('from_currency', Column.varchar),
        SchemaColumn('to_currency', Column.varchar),
        SchemaColumn('rate', Column.Double),
        SchemaColumn('effective_date', Column.datetime),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'LendingBorrowingTransaction',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn(
          'transaction_Transaction_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Transaction',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'counter_party_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: false,
          onDeleteSetDefault: true,
        ),
        SchemaColumn('counter_party_name', Column.varchar),
        SchemaColumn('payback_amount', Column.Double),
        SchemaColumn('transaction_id', Column.varchar, unique: true),
        SchemaColumn('counter_party_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['transaction_id'], unique: true),
      },
    ),
    SchemaTable(
      'Merchant',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('address', Column.varchar),
        SchemaColumn('lat', Column.Double),
        SchemaColumn('lng', Column.Double),
        SchemaColumn('metadata', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('user_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'PaybackLink',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'original_transaction_Transaction_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Transaction',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'payback_transaction_Transaction_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Transaction',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('payback_transaction_id', Column.varchar),
        SchemaColumn('original_transaction_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Profile',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn('fcm_token', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Recurrence',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('cron_string', Column.varchar),
        SchemaColumn('recurrence_type', Column.integer),
        SchemaColumn('description', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('user_id', Column.varchar),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'SavingsWallet',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn(
          'wallet_Wallet_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Wallet',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('savings_goal', Column.Double),
        SchemaColumn('wallet_id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['wallet_id'], unique: true),
      },
    ),
    SchemaTable(
      'Transaction',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar, unique: true),
        SchemaColumn(
          'profile_Profile_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Profile',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'wallet_Wallet_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Wallet',
          onDeleteCascade: true,
          onDeleteSetDefault: false,
        ),
        SchemaColumn(
          'category_Category_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Category',
          onDeleteCascade: false,
          onDeleteSetDefault: true,
        ),
        SchemaColumn('transaction_type', Column.integer),
        SchemaColumn('amount', Column.Double),
        SchemaColumn('transaction_date', Column.datetime),
        SchemaColumn('notes', Column.varchar),
        SchemaColumn('image_attachment', Column.varchar),
        SchemaColumn(
          'recurrence_Recurrence_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Recurrence',
          onDeleteCascade: false,
          onDeleteSetDefault: true,
        ),
        SchemaColumn('transfer_id', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn(
          'merchant_Merchant_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'Merchant',
          onDeleteCascade: false,
          onDeleteSetDefault: true,
        ),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
  },
);
