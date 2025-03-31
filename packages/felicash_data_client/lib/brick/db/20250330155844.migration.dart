// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250330155844_up = [
  InsertTable('PaybackLink'),
  InsertColumn('id', Column.varchar, onTable: 'PaybackLink', unique: true),
  InsertForeignKey('PaybackLink', 'Transaction', foreignKeyColumn: 'original_transaction_Transaction_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('PaybackLink', 'Transaction', foreignKeyColumn: 'payback_transaction_Transaction_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  CreateIndex(columns: ['id'], onTable: 'PaybackLink', unique: true)
];

const List<MigrationCommand> _migration_20250330155844_down = [
  DropTable('PaybackLink'),
  DropColumn('id', onTable: 'PaybackLink'),
  DropColumn('original_transaction_Transaction_brick_id', onTable: 'PaybackLink'),
  DropColumn('payback_transaction_Transaction_brick_id', onTable: 'PaybackLink'),
  DropIndex('index_PaybackLink_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250330155844',
  up: _migration_20250330155844_up,
  down: _migration_20250330155844_down,
)
class Migration20250330155844 extends Migration {
  const Migration20250330155844()
    : super(
        version: 20250330155844,
        up: _migration_20250330155844_up,
        down: _migration_20250330155844_down,
      );
}
