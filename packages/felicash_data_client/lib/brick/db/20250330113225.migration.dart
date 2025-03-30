// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250330113225_up = [
  InsertTable('ExchangeRate'),
  InsertColumn('id', Column.varchar, onTable: 'ExchangeRate', unique: true),
  InsertColumn('from_currency', Column.varchar, onTable: 'ExchangeRate'),
  InsertColumn('to_currency', Column.varchar, onTable: 'ExchangeRate'),
  InsertColumn('rate', Column.Double, onTable: 'ExchangeRate'),
  InsertColumn('effective_date', Column.datetime, onTable: 'ExchangeRate'),
  InsertColumn('created_at', Column.datetime, onTable: 'ExchangeRate'),
  InsertColumn('updated_at', Column.datetime, onTable: 'ExchangeRate'),
  CreateIndex(columns: ['id'], onTable: 'ExchangeRate', unique: true)
];

const List<MigrationCommand> _migration_20250330113225_down = [
  DropTable('ExchangeRate'),
  DropColumn('id', onTable: 'ExchangeRate'),
  DropColumn('from_currency', onTable: 'ExchangeRate'),
  DropColumn('to_currency', onTable: 'ExchangeRate'),
  DropColumn('rate', onTable: 'ExchangeRate'),
  DropColumn('effective_date', onTable: 'ExchangeRate'),
  DropColumn('created_at', onTable: 'ExchangeRate'),
  DropColumn('updated_at', onTable: 'ExchangeRate'),
  DropIndex('index_ExchangeRate_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250330113225',
  up: _migration_20250330113225_up,
  down: _migration_20250330113225_down,
)
class Migration20250330113225 extends Migration {
  const Migration20250330113225()
    : super(
        version: 20250330113225,
        up: _migration_20250330113225_up,
        down: _migration_20250330113225_down,
      );
}
