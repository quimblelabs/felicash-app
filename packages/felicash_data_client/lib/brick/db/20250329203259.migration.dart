// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250329203259_up = [
  DropColumn('user_id', onTable: 'Transaction'),
  DropColumn('wallet_id', onTable: 'Transaction'),
  DropColumn('category_id', onTable: 'Transaction'),
  DropColumn('recurrence_id', onTable: 'Transaction'),
  DropColumn('merchant_id', onTable: 'Transaction')
];

const List<MigrationCommand> _migration_20250329203259_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250329203259',
  up: _migration_20250329203259_up,
  down: _migration_20250329203259_down,
)
class Migration20250329203259 extends Migration {
  const Migration20250329203259()
    : super(
        version: 20250329203259,
        up: _migration_20250329203259_up,
        down: _migration_20250329203259_down,
      );
}
