// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250326132051_up = [
  InsertTable('Wallet'),
  InsertTable('CreditWallet'),
  InsertColumn('id', Column.varchar, onTable: 'Wallet', unique: true),
  InsertColumn('user_id', Column.varchar, onTable: 'Wallet'),
  InsertColumn('wallet_type', Column.integer, onTable: 'Wallet'),
  InsertColumn('name', Column.varchar, onTable: 'Wallet'),
  InsertColumn('description', Column.varchar, onTable: 'Wallet'),
  InsertColumn('base_currency', Column.varchar, onTable: 'Wallet'),
  InsertColumn('balance', Column.Double, onTable: 'Wallet'),
  InsertColumn('created_at', Column.datetime, onTable: 'Wallet'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Wallet'),
  InsertColumn('exclude_from_total', Column.boolean, onTable: 'Wallet'),
  InsertColumn('archived', Column.boolean, onTable: 'Wallet'),
  InsertColumn('archived_at', Column.datetime, onTable: 'Wallet'),
  InsertColumn('archive_reason', Column.varchar, onTable: 'Wallet'),
  InsertForeignKey('CreditWallet', 'Wallet', foreignKeyColumn: 'wallet_Wallet_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  CreateIndex(columns: ['id'], onTable: 'Wallet', unique: true)
];

const List<MigrationCommand> _migration_20250326132051_down = [
  DropTable('Wallet'),
  DropTable('CreditWallet'),
  DropColumn('id', onTable: 'Wallet'),
  DropColumn('user_id', onTable: 'Wallet'),
  DropColumn('wallet_type', onTable: 'Wallet'),
  DropColumn('name', onTable: 'Wallet'),
  DropColumn('description', onTable: 'Wallet'),
  DropColumn('base_currency', onTable: 'Wallet'),
  DropColumn('balance', onTable: 'Wallet'),
  DropColumn('created_at', onTable: 'Wallet'),
  DropColumn('updated_at', onTable: 'Wallet'),
  DropColumn('exclude_from_total', onTable: 'Wallet'),
  DropColumn('archived', onTable: 'Wallet'),
  DropColumn('archived_at', onTable: 'Wallet'),
  DropColumn('archive_reason', onTable: 'Wallet'),
  DropColumn('wallet_Wallet_brick_id', onTable: 'CreditWallet'),
  DropIndex('index_Wallet_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250326132051',
  up: _migration_20250326132051_up,
  down: _migration_20250326132051_down,
)
class Migration20250326132051 extends Migration {
  const Migration20250326132051()
    : super(
        version: 20250326132051,
        up: _migration_20250326132051_up,
        down: _migration_20250326132051_down,
      );
}
