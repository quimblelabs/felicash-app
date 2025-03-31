import 'package:brick_offline_first_with_rest/offline_queue.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:felicash_data_client/brick/brick.g.dart';
import 'package:felicash_data_client/brick/db/schema.g.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template felicash_data_client}
/// Felicash data client
/// {@endtemplate}
class FelicashDataClient extends OfflineFirstWithSupabaseRepository {
  /// {@macro felicash_data_client}
  ///
  /// Creates a new [FelicashDataClient] instance.
  /// - `supabaseClient` is the Supabase client to use for the data client.
  /// - `queue` is the queue to use for the data client.
  /// - `dbName` is the name of the database to use for the data client.
  ///  eg: 'my_repository.sqlite'
  factory FelicashDataClient({
    required SupabaseClient supabaseClient,
    required RestOfflineRequestQueue queue,
    required String dbName,
  }) {
    assert(dbName.isNotEmpty, 'dbName cannot be empty');
    assert(dbName.endsWith('.sqlite'), 'dbName must end with .sqlite');
    final provider = SupabaseProvider(
      supabaseClient,
      modelDictionary: supabaseModelDictionary,
    );
    return FelicashDataClient._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        dbName,
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  /// {@macro felicash_data_client}
  FelicashDataClient._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });
}
