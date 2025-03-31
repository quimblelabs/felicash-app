// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250330114131_up = [
  InsertForeignKey('LendingBorrowingTransaction', 'Profile', foreignKeyColumn: 'counter_party_Profile_brick_id', onDeleteCascade: false, onDeleteSetDefault: true)
];

const List<MigrationCommand> _migration_20250330114131_down = [
  DropColumn('counter_party_Profile_brick_id', onTable: 'LendingBorrowingTransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250330114131',
  up: _migration_20250330114131_up,
  down: _migration_20250330114131_down,
)
class Migration20250330114131 extends Migration {
  const Migration20250330114131()
    : super(
        version: 20250330114131,
        up: _migration_20250330114131_up,
        down: _migration_20250330114131_down,
      );
}
