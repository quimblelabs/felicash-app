// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250329203122_up = [
  DropColumn('category_Category_brick_id', onTable: 'Transaction'),
  InsertForeignKey('Transaction', 'Category', foreignKeyColumn: 'category_id_Category_brick_id', onDeleteCascade: false, onDeleteSetDefault: true)
];

const List<MigrationCommand> _migration_20250329203122_down = [
  DropColumn('category_id_Category_brick_id', onTable: 'Transaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250329203122',
  up: _migration_20250329203122_up,
  down: _migration_20250329203122_down,
)
class Migration20250329203122 extends Migration {
  const Migration20250329203122()
    : super(
        version: 20250329203122,
        up: _migration_20250329203122_up,
        down: _migration_20250329203122_down,
      );
}
