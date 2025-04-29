import 'dart:async';

import 'package:felicash_data_client/src/models/models.dart';
import 'package:felicash_data_client/src/models/schema.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template felicash_data_client}
/// Felicash data client
/// {@endtemplate}
class FelicashDataClient {
  /// {@macro felicash_data_client}
  FelicashDataClient._({
    required PowerSyncDatabase db,
    required SupabaseClient supabaseClient,
  }) : _db = db,
       _supabaseClient = supabaseClient;

  late final PowerSyncDatabase _db;
  FelicashBackendConnector? _connector;
  late final SupabaseClient _supabaseClient;
  StreamSubscription<AuthState>? _authSubscription;

  /// PowerSync database getter for the data client.
  PowerSyncDatabase get db => _db;

  /// Backend connector for PowerSync.
  FelicashBackendConnector? get connector => _connector;

  /// Supabase client getter
  SupabaseClient get supabaseClient => _supabaseClient;

  /// Check if user is currently logged in
  bool isLoggedIn() {
    return _supabaseClient.auth.currentSession?.accessToken != null;
  }

  /// Get ID of currently logged in user
  String? getUserId() {
    return _supabaseClient.auth.currentSession?.user.id;
  }

  /// Get the database file path
  Future<String> getDatabasePath(String dbFilename) async {
    // getApplicationSupportDirectory is not supported on Web
    if (kIsWeb) {
      return dbFilename;
    }
    final dir = await getApplicationSupportDirectory();
    return join(dir.path, dbFilename);
  }

  /// Create a new Felicash data client.
  ///
  /// [dbName] is the name of the database to create.
  ///
  /// [dbName] must end with `.db`.
  ///
  /// [dbName] must not be empty.
  ///
  /// [endpoint] is the PowerSync endpoint URL.
  ///
  /// [supabaseClient] is the Supabase client instance.
  ///
  /// [logger] is an optional logger for PowerSync.
  static Future<FelicashDataClient> create({
    required String dbName,
    required String endpoint,
    required SupabaseClient supabaseClient,
    Logger? logger,
  }) async {
    assert(dbName.isNotEmpty, 'dbName cannot be empty');
    assert(dbName.endsWith('.db'), 'dbName must end with .db');

    // Get database path
    final path = await _getDatabasePath(dbName);

    // Set up the database
    final db = PowerSyncDatabase(schema: schema, path: path, logger: logger);

    // Initialize the database
    await db.initialize();

    // Create the client instance
    final client = FelicashDataClient._(db: db, supabaseClient: supabaseClient)
      // Set up auth state change listener
      .._setupAuthListener(endpoint);

    // If already logged in, connect immediately
    if (client.isLoggedIn()) {
      client._connectToDatabase(endpoint);
    }

    return client;
  }

  /// Get the database file path
  static Future<String> _getDatabasePath(String dbFilename) async {
    // getApplicationSupportDirectory is not supported on Web
    if (kIsWeb) {
      return dbFilename;
    }
    final dir = await getApplicationSupportDirectory();
    return join(dir.path, dbFilename);
  }

  /// Set up the auth state change listener
  void _setupAuthListener(String endpoint) {
    _authSubscription?.cancel();

    _authSubscription = _supabaseClient.auth.onAuthStateChange.listen((
      data,
    ) async {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        // Connect to PowerSync when the user is signed in
        _connectToDatabase(endpoint);
      } else if (event == AuthChangeEvent.signedOut) {
        // Implicit sign out - disconnect, but don't delete data
        _connector = null;
        await _db.disconnect();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        // Supabase token refreshed - trigger token refresh for PowerSync
        await _connector?.prefetchCredentials();
      }
    });
  }

  /// Connect to the PowerSync database
  void _connectToDatabase(String endpoint) {
    _connector = FelicashBackendConnector(
      _db,
      endpoint: endpoint,
      supabaseClient: _supabaseClient,
    );
    _db.connect(connector: _connector!);
  }

  /// Explicit sign out - clear database and log out.
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
    await _db.disconnectAndClear();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _authSubscription?.cancel();
    await _db.disconnect();
  }
}

/// Backend connector for PowerSync to handle authentication and
/// data synchronization.
class FelicashBackendConnector extends PowerSyncBackendConnector {
  /// Create a new backend connector.
  FelicashBackendConnector(
    this.db, {
    required this.endpoint,
    required this.supabaseClient,
  });

  /// Database to connect to.
  final PowerSyncDatabase db;

  /// PowerSync endpoint URL.
  final String endpoint;

  /// Supabase client instance.
  final SupabaseClient supabaseClient;

  Future<void>? _refreshFuture;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // Wait for pending session refresh if any
    await _refreshFuture;

    // Use Supabase token for PowerSync
    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      // Not logged in
      return null;
    }

    // Use the access token to authenticate against PowerSync
    final token = session.accessToken;

    // userId and expiresAt are for debugging purposes only
    final userId = session.user.id;
    final expiresAt =
        session.expiresAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);

    return PowerSyncCredentials(
      endpoint: endpoint,
      token: token,
      userId: userId,
      expiresAt: expiresAt,
    );
  }

  /// Prefetch credentials to refresh the token
  @override
  Future<PowerSyncCredentials?> prefetchCredentials() {
    return fetchCredentials();
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync
    _refreshFuture = supabaseClient.auth
        .refreshSession()
        .timeout(const Duration(seconds: 5))
        .then((response) => null, onError: (error) => null);
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    final rest = supabaseClient.rest;
    final tableId = <String, String>{
      BudgetTracking.tableName: BudgetTrackingFields.budgetTrackingId,
      Budget.tableName: BudgetFields.budgetId,
      Category.tableName: CategoryFields.categoryId,
      CreditWallet.tableName: CreditWalletFields.creditWalletId,
      ExchangeRate.tableName: ExchangeRateFields.exchangeRateId,
      LendingBorrowingTransaction.tableName:
          LendingBorrowingTransactionFields.lendingBorrowingTransactionId,
      Merchant.tableName: MerchantFields.merchantId,
      PaybackLink.tableName: PaybackLinkFields.paybackLinkId,
      Profile.tableName: ProfileFields.profileId,
      Recurrence.tableName: RecurrenceFields.recurrenceId,
      SavingsWallet.tableName: SavingsWalletFields.savingsWalletId,
      Transaction.tableName: TransactionFields.transactionId,
      Wallet.tableName: WalletFields.walletId,
    };

    try {
      for (final op in transaction.crud) {
        final table = rest.from(op.table);
        switch (op.op) {
          case UpdateType.put:
            final data = Map<String, dynamic>.of(op.opData!);
            data[tableId[op.table]!] = op.id;
            await table.upsert(data);
          case UpdateType.patch:
            await table.update(op.opData!).eq(tableId[op.table]!, op.id);
          case UpdateType.delete:
            await table.delete().eq(tableId[op.table]!, op.id);
        }
      }

      // All operations successful
      await transaction.complete();
    } catch (e) {
      // Handle errors appropriately
      // For production code, you would want to add more
      // sophisticated error handling
      rethrow;
    }
  }
}
