// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250326132051.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{const Migration20250326132051()};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  20250326132051,
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
        SchemaColumn('user_id', Column.varchar),
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
      },
      indices: <SchemaIndex>{},
    ),
  },
);
