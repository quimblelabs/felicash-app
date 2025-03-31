import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:felicash_data_client/src/models/transaction.model.dart';

/// {@template exchange_rate_model}
/// Model for exchange rate.
/// {@endtemplate}
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'lending_borrowing_transactions',
  ),
)
// ignore: must_be_immutable
class LendingBorrowingTransaction extends OfflineFirstWithSupabaseModel
    with EquatableMixin {
  /// {@macro lending_borrowing_transaction_model}
  LendingBorrowingTransaction({
    required this.transaction,
    required this.paybackAmount,
    this.counterParty,
    this.counterPartyName,
  });

  /// Id of the lending borrowing transaction
  @Supabase(
    foreignKey: 'transaction_id',
    name: 'transaction_id',
    fromGenerator:
        'await TransactionAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.transaction.id',
  )
  @Sqlite(onDeleteCascade: true)
  final Transaction transaction;

  /// Counter party of the lending borrowing transaction
  /// This is the profile of the user who is lending or borrowing money
  /// from the current user
  @Supabase(
    defaultValue: 'null',
    foreignKey: 'counter_party_id',
    name: 'counter_party_id',
    fromGenerator:
        'await ProfileAdapter().fromSupabase( '
        '%DATA_PROPERTY% as Map<String, dynamic>, '
        'provider: provider, '
        'repository: repository,)',
    toGenerator: 'instance.counterParty?.id',
  )
  @Sqlite(
    defaultValue: 'null',
    onDeleteSetDefault: true,
    fromGenerator:
        '(%DATA_PROPERTY% as int > -1 '
        '? (await repository.getAssociation<Profile>( '
        'Query.where("primaryKey", %DATA_PROPERTY% as int, limit1: true, '
        ')))?.first : null)',
  )
  final Profile? counterParty;

  /// Name of the counter party
  final String? counterPartyName;

  /// Amount of the lending borrowing transaction
  /// This is the amount of money that is lent or borrowed
  final double paybackAmount;

  /// Get the id of the transaction
  @Supabase(unique: true, ignoreTo: true)
  @Sqlite(index: true, unique: true, ignoreTo: true)
  String get transactionId => transaction.id;

  /// Get the id of the counter party
  @Supabase(ignoreTo: true)
  @Sqlite(ignoreTo: true)
  String? get counterPartyId => counterParty?.id;

  @override
  List<Object?> get props => [];
}
